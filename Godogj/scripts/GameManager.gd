extends Node

var RunNumber : int = 1
var Score : int = 0
var ScorePerKill : int = 1

signal ResetLevel(reload_level)
var DebugTimerToTestLevelReset : float = 15.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugTimerToTestLevelReset -= delta
	if DebugTimerToTestLevelReset < 0.0:
		ResetGame()
		DebugTimerToTestLevelReset = 15.0
	
func ResetGame() -> void:
	RunNumber += 1
	Score = 0
	ResetLevel.emit()

func PlayerKilledEnemy() -> void:
	Score += ScorePerKill

func RegisterHit(Instigator:Node3D, Receiver: Node3D) -> void:
	if Instigator is Player and Receiver is Enemy:
		Receiver.Kill()
		PlayerKilledEnemy()
		
	if Instigator is Enemy and Receiver is Player:
		Receiver.Kill()
		ResetGame()
