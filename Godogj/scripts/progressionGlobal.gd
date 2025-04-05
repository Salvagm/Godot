extends Node

var levelOne = "res://scene_1.tscn"
var levelTwo = "res://scene_1.tscn"

var current_level = 1
var current_scene = null

var currentLevelTime = 10.0

func _ready():
	current_scene = get_tree().current_scene

func _process(delta: float):
	currentLevelTime -= delta
	
	if currentLevelTime < 0.0:
		level_complete()

	
func get_time_for_current_level():
	return currentLevelTime
	
func level_complete():
	goto_scene(levelTwo)

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
