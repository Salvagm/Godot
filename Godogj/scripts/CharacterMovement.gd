extends CharacterBody3D

@onready var animation_tree: AnimationTree = $Model/AnimationTree

var IsRunning : float = 0.0
var IsJumping : float = 0.0

const SPEED = 8.5
const JUMP_VELOCITY = 5

func update_anim_tree():
	animation_tree["parameters/Run/blend_amount"] = IsRunning
	animation_tree["parameters/Jump/blend_amount"] = IsJumping


func _process(delta: float) -> void:
	update_anim_tree()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(&"MoveLeft", &"MoveRight", &"MoveUp", &"MoveDown")
	var lookAt_Direction := Vector3(input_dir.x, 0, input_dir.y)
	var lookAt_Position = transform.origin + lookAt_Direction * 2
	var moveDirection := -lookAt_Direction.normalized()
	
	if lookAt_Direction:
		look_at(lookAt_Position)
	
	if moveDirection:
		velocity.x = moveDirection.x * SPEED
		velocity.z = moveDirection.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if velocity:
		if is_on_floor():
			IsRunning = 1.0
			IsJumping = 0.0
		else:
			IsRunning = 0.0
			IsJumping = 1.0
	else:
		IsRunning = 0.0
		IsJumping = 0.0

	move_and_slide()
