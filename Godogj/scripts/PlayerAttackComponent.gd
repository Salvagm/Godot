extends Node

@onready var off_hand_collision_area: Area3D = $"../Model/Rig/Skeleton3D/1H_Axe_Offhand/1H_Axe_Offhand/OffHandCollisionArea"
@onready var main_hand_collision_area: Area3D = $"../Model/Rig/Skeleton3D/1H_Axe/1H_Axe/MainHandCollisionArea"
@onready var player_root: CharacterBody3D = $".."

var BodiesInContact : Array[Node3D]
var BodiesInContactWithMainHand : Array[Node3D]
var BodiesInContactWithOffHand : Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_root.DamageEnabled:
		var BodiesToProcessHit : Array[Node3D]
		for Body in BodiesInContactWithOffHand:
			if player_root.IsSpecialAttack: #off hand only used when in special attack
				BodiesToProcessHit.push_back(Body)
		for Body in BodiesInContactWithMainHand:
			if not BodiesToProcessHit.has(Body): #check if wasn't added by the offhand weapon
				BodiesToProcessHit.push_back(Body)
				
		for Body in BodiesToProcessHit:
			GameManager.RegisterHit(player_root, Body)
			print(Body.to_string() + " damaged")
			
		BodiesInContact.clear()
		BodiesInContactWithOffHand.clear()
		BodiesInContactWithMainHand.clear()

func _on_off_hand_collision_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	var other_shape_owner_id = area.shape_find_owner(area_shape_index)
	var other_shape_node = area.shape_owner_get_owner(other_shape_owner_id)
	var other_shape_owner = other_shape_node.get_owner()
	GameManager.RegisterHit(player_root, other_shape_owner)


func RefreshBodiesInContact() ->void:
	var BodiesToKeep : Array[Node3D]
	for Body in BodiesInContact:
		if BodiesInContactWithOffHand.has(Body) or BodiesInContactWithMainHand.has(Body):
			BodiesToKeep.push_back(Body)
		else:
			print(Body.to_string() + " exited")
	BodiesInContact = BodiesToKeep		
			
func _on_off_hand_collision_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		if not BodiesInContact.has(body):
			print(body.to_string() + " entered")
			BodiesInContact.push_back(body)
		BodiesInContactWithOffHand.push_back(body)

func _on_off_hand_collision_area_body_exited(body: Node3D) -> void:
	if BodiesInContactWithOffHand.has(body):
		var BodyIndexOffhand : int = BodiesInContactWithOffHand.find(body)
		BodiesInContactWithOffHand.remove_at(BodyIndexOffhand)
		RefreshBodiesInContact()

func _on_main_hand_collision_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		if not BodiesInContact.has(body):
			print(body.to_string() + " entered")
			BodiesInContact.push_back(body)
		BodiesInContactWithMainHand.push_back(body)

func _on_main_hand_collision_area_body_exited(body: Node3D) -> void:
	if BodiesInContactWithMainHand.has(body):
		var BodyIndexMainHand : int = BodiesInContactWithMainHand.find(body)
		BodiesInContactWithMainHand.remove_at(BodyIndexMainHand)
		RefreshBodiesInContact()
