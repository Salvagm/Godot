extends Node2D

var current_game_level = null
var max_game_time = 6000.0
var current_game_time = 0.0
var levelOne = "res://scenes/game.tscn"

func load_new_game_level() ->void:
	if current_game_level:
		remove_child(current_game_level)
		current_game_level.free()
		print_debug("current level deleted")

	current_game_time = max_game_time
	
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
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_game_level = s.instantiate()
	
	# Add it to the active scene, as child of root.
	add_child(current_game_level)
	
	current_game_level.position = Vector2(-648, -638)
	
	print_debug("new level created")
