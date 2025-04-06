extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var RunNumber = GameManager.RunNumber as int
	var RunScore = GameManager.Score as int
	var StringToFormat = "run: {run}\nscore: {score}"
	var StringToPrint = StringToFormat.format({"run" =RunNumber, "score" =RunScore})
	text = StringToPrint
