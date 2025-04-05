extends Node2D

var current_game_level = null
var max_game_time = 5.0
var current_game_time = 0.0
var levelOne = "res://scenes/game.tscn"

var creation = 0

func load_new_game_level() ->void:
	if current_game_level:
		remove_child(current_game_level)
		current_game_level.free()
		print_debug("current level deleted")

	creation += 1
	current_game_time = max_game_time
	
	#if creation < 2:
	goto_scene(levelOne)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not current_game_level:
		load_new_game_level() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_game_time -= delta
	
	if current_game_time <= 0:
		load_new_game_level()

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point isd
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	#_deferred_goto_scene.call_deferred(path)
	
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_game_level = s.instantiate()
	
	# Add it to the active scene, as child of root.
	add_child(current_game_level)
	
	print_debug("new level created")
