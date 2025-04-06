extends Camera3D

var DistanceToPlayer = Vector3(0.0, 10, -1.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var PlayerNode = get_tree().current_scene.get_node("Player")
	var PlayerLocation = PlayerNode.transform.origin
	var Cameralocation = PlayerLocation + DistanceToPlayer;
	transform.origin = Cameralocation
