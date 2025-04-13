class_name EnemyWeapon extends Node3D

@export var weapon_range_meters:= 5.0 as float
@export var weapon_cooldown_seconds:= 1.0 as float
@export var weapon_attack_speed:= 1.0 as float
@export var attack_animations: Array[StringName]

@onready var area_3d: Area3D = $Area3D
@onready var weaponRangeMeterSqr = weapon_range_meters * weapon_range_meters

var Owner: Enemy
var weaponUseTime:= 0.0 as float
var isAttacking: bool = false

func _ready() -> void:
	area_3d.body_shape_entered.connect(on_weapon_hit)
	area_3d.monitoring = false

func _physics_process(delta: float) -> void:
	var animPLayer: AnimationPlayer = Owner.animation_player
	
	if not is_attacking():
		return
	enable_hitbox(animPLayer.current_animation_position)

func enable_hitbox(animPostion: float)-> void:
	area_3d.monitoring = animPostion >= 0.75 && animPostion <= 0.9

func set_character_owner(newOwner: Enemy):
	Owner = newOwner

func in_cooldown() -> bool:
	var currentTime = Time.get_ticks_msec()
	var cooldownEndTime = weaponUseTime + weapon_cooldown_seconds * 1000

	return cooldownEndTime > currentTime 

func in_range(inTargetPostion: Vector3) -> bool:
	var targetPostionSqr = Owner.global_position.distance_squared_to(inTargetPostion)
	return targetPostionSqr <= weaponRangeMeterSqr

func can_use_weapon(inTargetPostion: Vector3) -> bool:
	var isNotAttacking:= not is_attacking() as bool
	var notCD := not in_cooldown() as bool
	var inRange := in_range(inTargetPostion) as bool

	return isNotAttacking && notCD && inRange

func is_attacking() -> bool:
	return isAttacking

func use_weapon() -> void:
	var animPLayer: AnimationPlayer = Owner.animation_player
	var animTree: AnimationTree = Owner.animation_tree
	animTree.active = false
	isAttacking = true
	var currentAttackAnimation = attack_animations[randi_range(0, attack_animations.size() - 1)]
	weaponUseTime = Time.get_ticks_msec()
	animPLayer.animation_finished.connect(on_attack_finish)
	animPLayer.play(currentAttackAnimation,1, weapon_attack_speed)

func on_attack_finish(anim_name: StringName):
	var animPLayer: AnimationPlayer = Owner.animation_player
	var animTree: AnimationTree = Owner.animation_tree

	animPLayer.animation_finished.disconnect(on_attack_finish)

	animTree.active = true
	isAttacking = false

func on_weapon_hit(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		GameManager.RegisterHit(Owner, body)
