extends CharacterBody2D

@export var speed: float = 300.0
@export var push_force: float = 10.0

func _physics_process(delta):
	# Get input direction
	var input_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	
	# Normalize diagonal movement
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	# Calculate velocity
	velocity = input_direction * speed
	
	# Move the character and check for collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision and collision.get_collider() is CharacterBody2D:
		# Use collision normal to determine bounce direction
			if Input.is_action_just_pressed("Shoot"):
				var rb = collision.get_collider()
				var force = -collision.get_normal() * push_force
				rb.velocity = force
		 
