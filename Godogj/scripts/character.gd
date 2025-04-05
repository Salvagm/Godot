class_name Player
extends RigidBody2D

@export var speed: float = 350.0
@export var decceleration: float = 400.0
@export var push_force: float = 4.0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity := state.get_linear_velocity()
	var step := state.get_step()
	
	# Get input direction
	var input_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown");
	var input_pressed = input_direction.length();
	var shoot_presed = Input.is_action_just_released("Shoot");

	# Normalize diagonal movement
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()

	# Calculate velocity
	var final_speed = speed
	if shoot_presed == true: 
		final_speed *= push_force

	if input_pressed > 0:
		velocity = input_direction * final_speed
	else:
		velocity = velocity - velocity * decceleration * step * step
	
	state.set_linear_velocity(velocity)
