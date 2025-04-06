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
@onready var destination:= currentScene.get_node("target") as Marker3D
@onready var navSystem:= $NavigationAgent3D as NavigationAgent3D
@onready var player: Player = currentScene.get_node("Level").get_node("Player")

var LastKnownLocation: Vector3
var IsDead:= false as bool
var CurrentTarget: Player = null
var visionDistanceSquared: float = 0.0
var coneRangeValue: float = 0.0

func _ready() -> void:
	visionDistanceSquared = vision_distance_meters * vision_distance_meters
	coneRangeValue = cos(deg_to_rad(vision_cone_degrees))
	LastKnownLocation = global_position

func _physics_process(delta: float) -> void:
	update_target(delta)
	update_look_direction()	
	find_location_to_move()
	move_to_target(delta)

func update_target(delta: float):

	var playerLocation = player.global_transform.origin
	var currentLocation = global_transform.origin	
	#draw_line(currentScene.global_position + playerLocation, currentScene.global_position + currentLocation, Color.PINK)
	
	 #Not in distance range
	if currentLocation.distance_squared_to(playerLocation) > visionDistanceSquared:
		return
	
	var faceDirection = global_transform.basis.z;
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

	var raycastOrigin = global_transform.origin + Vector3.UP * 1.6
	var raycastEnd = raycastOrigin + direction * vision_distance_meters

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(raycastOrigin, raycastEnd)
	query.collide_with_bodies = true
	query.collide_with_areas = true
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
		var lookDirection = velocity
		look_at(lookDirection)
		global_rotation.x = 0

func find_location_to_move():
	if CurrentTarget != null:
		navSystem.target_position = CurrentTarget.global_position

func Kill() -> void:
	IsDead = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		GameManager.RegisterHit($".", body)

@onready var level_debug_mesh: MeshInstance3D = currentScene.get_node("Level/LevelDebugMesh")
func draw_line(startPoint: Vector3, endPoint :Vector3, inColor: Color):
	var mat = StandardMaterial3D.new()
	mat.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = inColor
	
	level_debug_mesh.mesh = ImmediateMesh.new()
	level_debug_mesh.material_override = mat
	level_debug_mesh.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	level_debug_mesh.mesh.surface_add_vertex(startPoint)
	level_debug_mesh.mesh.surface_add_vertex(endPoint)
	level_debug_mesh.mesh.surface_end()
