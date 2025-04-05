extends CharacterBody3D
class_name Enemy

# Exposed variables to be modified in editor
@export var movement_speed : float = 10.0
@export var movement_acceleration : float = 5.0

# Initialize variables once before starting using them
@onready var currentScene: Node3D = get_tree().current_scene
@onready var destination: Marker3D = currentScene.get_node("target")
@onready var navSystem: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:

	if destination == null:
		return
	navSystem.target_position = destination.global_position
	var direction = navSystem.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * movement_speed, movement_acceleration * delta)
	move_and_slide()
