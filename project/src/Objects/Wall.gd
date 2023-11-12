extends Area2D

signal player_hit_wall
signal robot_hit_wall

func _on_Wall_body_entered(body):	
	if body.is_in_group("player"):
		emit_signal("player_hit_wall")
	if body.is_in_group("enemies"):
		emit_signal("robot_hit_wall")
