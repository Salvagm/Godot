extends Node3D

var StartingTransparency: float = 0.0
var CurrentTransparency: float = 0.0
var DesiredTransparency: float = 0.0
var LerpTimeLeft: float = 0.0
var LerptTotalTime: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ChildrenMeshes = find_children("*", "MeshInstance3D", true)
	for ChildMesh in ChildrenMeshes:
		var material : Material = ChildMesh.get_active_material(0)
		if material:
			if not material.resource_local_to_scene:
				material = material.duplicate()
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				material.flags_transparent = true
				ChildMesh.set_surface_override_material(0, material)
			else:
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				material.flags_transparent = true
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LerpTimeLeft > 0.0:
		LerpTimeLeft = max(0.0, LerpTimeLeft - delta)
		CurrentTransparency = remap(LerptTotalTime - LerpTimeLeft, 0.0, LerptTotalTime, StartingTransparency, DesiredTransparency)
		SetTransparency(CurrentTransparency, false)

func SetTransparency(transparency: float, force: bool = true) -> void:
	if force:
		LerpTimeLeft = 0.0
	
	CurrentTransparency = transparency
	
	var ChildrenMeshes = find_children("*", "MeshInstance3D", true)
	for ChildMesh in ChildrenMeshes:
		var material : Material = ChildMesh.get_active_material(0)
		if material:
			var color = material.albedo_color
			color.a = transparency
			material.albedo_color = color

func LerpTransparency(transparency: float, lerp_time: float = 0.0) -> void:
	if lerp_time:
		DesiredTransparency = transparency
		StartingTransparency = CurrentTransparency
		LerptTotalTime = lerp_time
		LerpTimeLeft = lerp_time
	else:
		DesiredTransparency = transparency
		LerpTimeLeft = 0.0
		SetTransparency(transparency, true)
		
