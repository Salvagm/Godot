class_name Enemy extends CharacterBody3D

# Exposed variables to be modified in editor
@export var movement_speed:= 10 as float
@export var movement_acceleration:= 5.0 as float
@export var movement_deceleration:= 10.0 as float

@export var vision_distance_meters:= 10 as float
@export var vision_cone_degrees:= 60 as float
@export var vision_eye_heigth:= 1.8 as float

# Initialize variables once before starting using them
@onready var currentScene:= get_tree().current_scene as Node3D
@onready var navSystem:= $NavigationAgent3D as NavigationAgent3D
@onready var player: Player = currentScene.get_node("Level").get_node("Player")
@onready var animation_player: AnimationPlayer
@onready var animation_tree: AnimationTree

var LastKnownLocation: Vector3
var IsDead:= false as bool
var CurrentTarget: Player = null
var visionDistanceSquared: float = 0.0
var coneRangeValue: float = 0.0
var enemyMesh: EnemyMesh
var equippedWeapon: EnemyWeapon

# TODO: Remove this and set the weapon to use in editor
var randomWeapon = [
	"res://scenes/enemies/Weapons/SkeleAxe.tscn", 
	#"res://scenes/enemies/Weapons/SkeleStaff.tscn", 
	#"res://scenes/enemies/Weapons/SkeleSword.tscn",
]

func _ready() -> void:
	var enemyMeshChildren = find_children("*", "EnemyMesh", false)
	if enemyMeshChildren.is_empty() == false:
		enemyMesh = enemyMeshChildren[0]
		load_weapon()
		animation_player = enemyMesh.get_node("AnimationPlayer")
		animation_tree = enemyMesh.get_node("AnimationTree")

	visionDistanceSquared = vision_distance_meters * vision_distance_meters
	coneRangeValue = cos(deg_to_rad(vision_cone_degrees))
	LastKnownLocation = global_position

func load_weapon() -> void:
	var weaponToPick = randi_range(0, randomWeapon.size() - 1)
	equippedWeapon = ResourceLoader.load(randomWeapon[weaponToPick]).instantiate()
	equippedWeapon.set_character_owner(self)
	enemyMesh.attach_to_hand(equippedWeapon, EnemyMesh.HandEnum.RIGHT)

func _physics_process(delta: float) -> void:
	if is_dead() or GameManager.IsGameOver:
		return
		
	
	update_target(delta)
	update_look_direction()	
	find_location_to_move()
	
	if CurrentTarget != null && equippedWeapon != null && equippedWeapon.can_use_weapon(CurrentTarget.global_position):
		equippedWeapon.use_weapon()
	if not equippedWeapon.is_attacking():
		move_to_target(delta)

func update_target(delta: float):
	var playerLocation = player.global_transform.origin
	var currentLocation = global_transform.origin	
	#draw_line(currentScene.global_position + playerLocation, currentScene.global_position + currentLocation, Color.PINK)
	
	 #Not in distance range
	if currentLocation.distance_squared_to(playerLocation) > visionDistanceSquared:
		return
	
	var faceDirection = enemyMesh.get_eye_transform().basis.z;
	var enemyToPlayerDirection = currentLocation.direction_to(playerLocation).normalized()	
	var dotResult = faceDirection.dot(enemyToPlayerDirection)

	# Not in cone
	if dotResult < coneRangeValue:
		return
		
	var hitResult = check_visibility(enemyToPlayerDirection)

	if hitResult.is_empty() == false and hitResult["collider"] is Player:
		CurrentTarget = hitResult["collider"]
	elif CurrentTarget != null:
		LastKnownLocation = CurrentTarget.global_position

func check_visibility(direction: Vector3) -> Dictionary:
	var space_state = get_world_3d().direct_space_state

	var raycastOrigin = enemyMesh.get_eye_location()
	var raycastEnd = raycastOrigin + direction * vision_distance_meters

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(raycastOrigin, raycastEnd)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.collision_mask = 0xFFFFFFFF
	query.exclude = [self]
	var hitResult = space_state.intersect_ray(query)
	return hitResult	

func is_dead() -> bool:
	return IsDead

func move_to_target(delta: float) -> void:
	if navSystem.is_target_reached():
		var current_speed = velocity.length()
		var velocity_direction = velocity.normalized()
		velocity = velocity_direction * lerpf(current_speed, 0, movement_deceleration * delta)
	else:
		var direction = navSystem.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * movement_speed, movement_acceleration * delta)

	move_and_slide()

func update_look_direction() -> void:
	#var lookDirection: Vector3 = Vector3.INF
	if velocity != Vector3.ZERO:
		look_at(CurrentTarget.global_position)
		global_rotation.x = 0

func find_location_to_move():
	if CurrentTarget != null:
		navSystem.target_position = CurrentTarget.global_position

func Kill() -> void:
	IsDead = true
	queue_free()
