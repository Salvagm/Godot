class_name Enemy extends CharacterBody3D

# Exposed variables to be modified in editor
@export var movement_speed:= 10 as float
@export var movement_acceleration:= 5.0 as float
@export var movement_deceleration:= 10.0 as float

# Initialize variables once before starting using them
@onready var currentScene:= get_tree().current_scene as Node3D
@onready var destination:= currentScene.get_node("target") as Marker3D
@onready var navSystem:= $NavigationAgent3D as NavigationAgent3D
@onready var enemyBrain: NewEnemyBrain = $NewEnemyBrain

var locationToMove: Vector3
var IsDead:= false as bool

func _ready() -> void:
	if destination == null:
		return
	locationToMove = destination.global_position
	
@onready var player: CharacterBody3D = $"../Player"

func _physics_process(delta: float) -> void:
	
	var space_state = get_world_3d().direct_space_state
	var raycastOrigin = global_transform.origin #+ global_transform.basis.z.normalized() * 1.3 + global_transform.basis.y.normalized() * 1.2;
	var raycastEnd = player.global_transform.origin# raycastOrigin + global_transform.basis.z.normalized() * 10
	

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(raycastOrigin, raycastEnd)
	query.collide_with_bodies = true
	#query.collide_with_areas = true
	query.collision_mask = collision_mask
	#query.exclude = [Owner]
	var hitResult: Dictionary = space_state.intersect_ray(query)
	#draw_spheres(raycastOrigin,raycastEnd, Color.YELLOW )

	#print(global_position)
	update_look_direction()
	move_to_target(delta)

func is_dead() -> bool:
	return IsDead

func set_target_to_move(target: Vector3) -> void:
	locationToMove = target

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
	var lookAtLocation: Vector3 = -navSystem.target_position;
	lookAtLocation.y = 0
	look_at(lookAtLocation)

func Kill() -> void:
	print("enemy dead")
	pass

func check_visibily_with_player(directionToLook: Vector3) -> Dictionary :
	var hitResult: Dictionary = {}
	var space_state = get_world_3d().direct_space_state
	
	var enemyForward = global_transform.basis.z.normalized()
	var enemyUp = global_transform.basis.y.normalized()	
	var forwardOffset = enemyForward * 1.2;
	var upOffset = enemyUp * 1.4;
	
	var raycastOrigin = global_transform.origin + upOffset
	var raycastEnd =  raycastOrigin + directionToLook * enemyBrain.VisionDistanceMeter
	draw_line(raycastOrigin, raycastEnd, Color.BLUE)
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(raycastOrigin, raycastEnd)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.collision_mask = 0xFFFFFFFF
	query.exclude = [self]
	hitResult = space_state.intersect_ray(query)

	return hitResult;

@onready var immediate_mesh = $ImmediateMesh
@onready var debug_mesh: MeshInstance3D = $"../DebugMesh"

func draw_line(startPoint: Vector3, endPoint :Vector3, inColor: Color):
	var mat = StandardMaterial3D.new()
	mat.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = inColor
	
	debug_mesh.mesh = ImmediateMesh.new()
	debug_mesh.material_override = mat
	debug_mesh.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	debug_mesh.mesh.surface_add_vertex(startPoint)
	debug_mesh.mesh.surface_add_vertex(endPoint)
	debug_mesh.mesh.surface_end()
