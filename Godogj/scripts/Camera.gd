extends Camera3D

var DistanceToPlayer = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var PlayerNode = get_tree().current_scene.get_node("Player")
	var PlayerLocation = PlayerNode.transform.origin
	var PlayerForward = -PlayerNode.transform.basis.z
	var Cameralocation = PlayerLocation + (PlayerForward * 1.5);
	Cameralocation.y = DistanceToPlayer;
	
	transform.origin = Cameralocation
