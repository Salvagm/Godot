class_name Player extends CharacterBody3D

@onready var animation_tree: AnimationTree = $Model/AnimationTree

var OffHandAttackStart : float = 0.5
var OffHandAttackEnd : float = 0.8
var DamageEnabled : bool = false

var IsRunning : float = 0.0
var IsJumping : float = 0.0
var IsAttacking : float = 0.0
var IsSpecialAttack : float = 0.0

var AttackCooldown : float = 0.0
var AttackTimer : float = 0.0

const SPEED = 8.5
const JUMP_VELOCITY = 5

func update_anim_tree():
	animation_tree["parameters/Run/blend_amount"] = IsRunning
	animation_tree["parameters/Jump/blend_amount"] = IsJumping
	animation_tree["parameters/Attack/add_amount"] = IsAttacking
	animation_tree["parameters/AttackBlendTree/IsSpecialAttack/blend_amount"] = IsSpecialAttack

func _input(event: InputEvent) -> void:
	if AttackCooldown <= 0.0:
		if event.is_action_pressed("AttackBasic"):
			IsAttacking = 1.0
			AttackCooldown = 1.0
			IsSpecialAttack = 0.0
			AttackTimer = 0
			animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		elif event.is_action_pressed("AttackSpecial"):
			IsAttacking = 1.0
			IsSpecialAttack = 1.0
			AttackCooldown = 1.2
			AttackTimer = 0
			animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			

func _process(delta: float) -> void:
	if AttackCooldown > 0:
		AttackCooldown -= delta
		if AttackCooldown <= 0.0:
			AttackCooldown = 0.0
			IsAttacking = 0.0
			IsSpecialAttack = 0.0
			DamageEnabled = false
	if IsAttacking > 0:
		AttackTimer += delta
		if IsSpecialAttack:
			DamageEnabled = AttackTimer >= 0.5 and AttackTimer < 0.8
		else:
			DamageEnabled = AttackTimer >= 0.3 and AttackTimer < 0.6
			
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
	
func Kill():
	pass
