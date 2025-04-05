extends CharacterBody2D

var bounce_factor = 1

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision and collision.get_collider():
		if collision.get_collider() is not CharacterBody2D:
			velocity = velocity.bounce(collision.get_normal()) * bounce_factor
		elif collision.get_collider() is CharacterBody2D:
			velocity = Vector2.ZERO
