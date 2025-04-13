class_name EnemyMesh extends Node3D

@onready var eye_height: Node3D = $Eye_height

func get_eye_height() -> Node3D:
	return eye_height
	
func get_eye_transform() -> Transform3D:
	return eye_height.global_transform

func get_eye_location() -> Vector3:
	return eye_height.global_position
