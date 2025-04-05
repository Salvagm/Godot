extends Area2D

func _ready():
	# Connect signals in Godot 4 style
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("ball"):
		# Optional effects before destruction
		body.hide()  # Make invisible immediately
		body.collision_layer = 0  # Disable collisions
		body.queue_free()  # Schedule deletion
