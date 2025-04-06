class_name Enemy extends CharacterBody3D

# Exposed variables to be modified in editor
@export var movement_speed:= 10 as float
@export var movement_acceleration:= 5.0 as float

# Initialize variables once before starting using them
@onready var currentScene:= get_tree().current_scene as Node3D
@onready var destination:= currentScene.get_node("target") as Marker3D
@onready var navSystem:= $NavigationAgent3D as NavigationAgent3D
@onready var animation_tree:= $AnimationTree as AnimationTree

func _ready() -> void:
	if destination == null:
		return
	navSystem.target_position = destination.global_position

func _physics_process(delta: float) -> void:
	var direction = navSystem.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * movement_speed, movement_acceleration * delta)
	move_and_slide()
