extends Node2D
class_name Weapon

@export var damage: int = 1
@export var projectile: PackedScene
@export var rate_of_fire: float = 120

@onready var _fire_pos: Node2D = $FirePos
@onready var _cooldown: float = 0

func _process(delta):
	_cooldown -= delta

func fire() -> void:
	if _cooldown > 0: 
		return
	var new_projectile = projectile.instantiate()
	new_projectile.position = _fire_pos.global_position
	new_projectile.damage = damage
	new_projectile.direction = rotation
	new_projectile.owner_id = $"..".owner_id
	$/root/Main/Game/Level.add_child(new_projectile, true)
	_cooldown = 60.0 / 120.0
