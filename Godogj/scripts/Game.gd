extends Node

var LevelPath = "res://scenes/level.tscn"
var CurrentGamelevel = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SwitchLevel()
	GameManager.PlayerDiedSignal.connect(_OnPlayerDied)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _OnPlayerDied():
	#Player Dead anim
	#Timer - 2 secs
	#Fade
	#UI
	#Fade to back
	SwitchLevel()
	pass

func SwitchLevel() ->void:
	if CurrentGamelevel:
		remove_child(CurrentGamelevel)
		CurrentGamelevel.free()
		print_debug("current level deleted")
	
	goto_scene(LevelPath)

func goto_scene(path):
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	CurrentGamelevel = s.instantiate()
	
	# Add it to the active scene, as child of root.
	add_child(CurrentGamelevel)
	
	print_debug("new level created")
