class_name EnemyAnimTree extends AnimationTree

enum AnimStates
{
	IDLE,
	RUN
}

var StateActions: Dictionary = {
	AnimStates.IDLE : idle,
	AnimStates.RUN : run
}

@export var CurrentAnimState:= AnimStates.IDLE as AnimStates
@export var RunValue:= 0 as float
@export var BlendSpeed:= 15 as float;

@onready var enemy: Enemy = $"../.."
@onready var AnimTree: EnemyAnimTree = $"."

func update_tree():
	AnimTree[&"parameters/Run/blend_amount"] = RunValue

func run(delta: float):
	RunValue = lerpf(RunValue, 1, BlendSpeed * delta)
	pass
	
func idle(delta: float):
	RunValue = lerpf(RunValue, 0, BlendSpeed * delta)
	pass

func _physics_process(delta: float) -> void:
	enemy.velocity
	if enemy.velocity.length() > 5:
		CurrentAnimState = AnimStates.RUN
	else:
		CurrentAnimState = AnimStates.IDLE
		
	StateActions[CurrentAnimState].call(delta)
	update_tree()
