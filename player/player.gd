extends CharacterBody2D
class_name PlayerCharacter

signal current_health_changed(current_health: int)
signal died(player: PlayerCharacter)

@export var speed = 300.0
@export var max_health = 100
@export var owner_id: int
@export var current_health = max_health:
	get:
		return current_health
	set(value):
		current_health = value
		current_health_changed.emit(current_health)

@onready var gun: Weapon = $Gun

func _ready():
	if owner_id == multiplayer.get_unique_id():
		GlobalData.local_player = self

func _physics_process(delta):
	if owner_id != multiplayer.get_unique_id(): return
	
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	move_and_slide()
	
	var mouse_pos = get_viewport().get_mouse_position()
	gun.look_at(mouse_pos)
	
	move.rpc(global_position)
	gun_look_at.rpc(mouse_pos)
	
	if Input.is_action_pressed("fire"):
		fire.rpc()

@rpc("authority", "call_local", "reliable")
func take_damage(amount: int, peer_id: int) -> void:
	current_health -= amount
	if current_health <= 0:
		died.emit(self)
		GlobalData.scored.rpc_id(peer_id)

@rpc("any_peer", "call_local", "unreliable")
func fire():
	gun.fire()
	
@rpc("any_peer", "call_remote", "unreliable")
func move(position: Vector2):
	self.global_position = position

@rpc("any_peer", "call_remote", "unreliable")
func gun_look_at(position: Vector2):
	gun.look_at(position)
