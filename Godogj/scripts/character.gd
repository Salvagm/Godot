extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(delta):
	# Get input direction
	var input_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	
	# Normalize diagonal movement
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
	
	# Calculate velocity
	velocity = input_direction * speed
	
	# Move the character
	move_and_slide()
