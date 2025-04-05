class_name Ball
extends RigidBody2D

var bounce_factor = 1
@export var min_movement_force: float = 400.0;

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity := state.get_linear_velocity()
	var step := state.get_step()
	
	for collider_index in state.get_contact_count():
		var collider := state.get_contact_collider_object(collider_index)
		var collision_normal := state.get_contact_local_normal(collider_index)
		
		if collider is Player:
			collision_normal = collision_normal * -1.0
			velocity = -collision_normal * collider.get_linear_velocity().length();
			if velocity.length() > min_movement_force:
				state.set_linear_velocity(velocity)
			else:
				collider.set_linear_velocity(collision_normal * 500)
				state.set_linear_velocity(-collision_normal)
