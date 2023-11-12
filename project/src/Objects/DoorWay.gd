extends Area2D

# Player walks into doorway, goto next level
func _on_DoorWay_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Set to reset the level for now
		GameState.next_level()
	elif body.is_in_group("enemies"):
		body.dead()
