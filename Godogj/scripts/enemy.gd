class_name Enemy extends CharacterBody3D

# Exposed variables to be modified in editor
@export var movement_speed:= 10 as float
@export var movement_acceleration:= 5.0 as float
@export var movement_deceleration:= 10.0 as float

# Initialize variables once before starting using them
@onready var currentScene:= get_tree().current_scene as Node3D
@onready var destination:= currentScene.get_node("target") as Marker3D
@onready var navSystem:= $NavigationAgent3D as NavigationAgent3D

func _ready() -> void:
	if destination == null:
		return
	navSystem.target_position = destination.global_position

func _physics_process(delta: float) -> void:
	update_look_direction()
	move_to_target(delta)


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
