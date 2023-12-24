extends PhysicsBody2D
class_name Bullet

@export var speed: int
var owner_id: int

var damage: int
var direction: float

func _process(delta):
	var max_x = get_viewport().get_visible_rect().size.x
	var max_y = get_viewport().get_visible_rect().size.y
	if position.x < 0 or position.x > max_x or position.y < 0 or position.y > max_y:
		queue_free()

func _physics_process(delta):
	var vec_dir = Vector2.RIGHT.rotated(direction)
	var velocity = vec_dir * speed
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		if multiplayer.is_server():
			var collider = collision.get_collider()
			if collider is PlayerCharacter:
				collider.take_damage(damage, owner_id)
		queue_free()
