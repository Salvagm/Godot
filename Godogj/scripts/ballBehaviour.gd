extends CharacterBody2D

var bounce_factor = 1

func _ready():
	add_to_group("ball")

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision and collision.get_collider():
		if collision.get_collider().is_in_group("player"):
			velocity = Vector2.ZERO
		else:
			velocity = velocity.bounce(collision.get_normal()) * bounce_factor
