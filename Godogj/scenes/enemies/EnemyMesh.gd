class_name EnemyMesh extends Node3D

@onready var eye_height: Node3D = $Eye_height

var right_hand_bone: BoneAttachment3D
var left_hand_bone: BoneAttachment3D

enum HandEnum
{
	LEFT,
	RIGHT
}

func _ready() -> void:
	right_hand_bone = find_child("*_HandR")
	left_hand_bone = find_child("*_HandL")

func get_eye_height() -> Node3D:
	return eye_height
	
func get_eye_transform() -> Transform3D:
	return eye_height.global_transform

func get_eye_location() -> Vector3:
	return eye_height.global_position

func attach_to_hand(Item : Node3D, hand : HandEnum) -> void:
	Item.transform = Transform3D.IDENTITY
	match hand:
		HandEnum.LEFT:
			left_hand_bone.add_child(Item)
		HandEnum.RIGHT:
			right_hand_bone.add_child(Item)
