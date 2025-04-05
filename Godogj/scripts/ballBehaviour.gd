class_name Ball
extends RigidBody2D

var bounce_factor = 1
@export var min_movement_force: float = 400.0;

@export var min_damp: float = 2.0;
@export var max_damp: float = 20.0;

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
				var pitRef = get_tree().get_first_node_in_group("pit")
				var PitPosition = pitRef.global_position
				
				var hitVelocityNormalized = velocity.normalized()
				var pitDirectionNormalized = (PitPosition - global_position).normalized()
				var PitAlignment = hitVelocityNormalized.dot(pitDirectionNormalized)
				
				linear_damp = map_range(PitAlignment, -1, 1, min_damp, max_damp)
				
				state.set_linear_velocity(velocity)
			else:
				linear_damp = max_damp

				collider.set_linear_velocity(collision_normal * 500)
				state.set_linear_velocity(-collision_normal)
				

# Range mapping function with correct tab indentation
func map_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	# First normalize the value to [0,1] range
	var normalized = (value - from_min) / (from_max - from_min)
	# Then interpolate to the target range
	return lerp(to_min, to_max, normalized)
