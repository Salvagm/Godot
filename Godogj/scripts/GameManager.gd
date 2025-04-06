extends Node

var RunNumber : int = 1
var Score : int = 0

func ResetGame() -> void:
	RunNumber += 1
	Score = 0
	#send event

func PlayerKilledEnemy() -> void:
	Score += 5

func RegisterHit(Instigator:Node3D, Receiver: Node3D) -> void:
	if Instigator is Player and Receiver is Enemy:
		Receiver.Kill()
		PlayerKilledEnemy()
		
	if Instigator is Enemy and Receiver is Player:
		Receiver.Kill()
		ResetGame()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
