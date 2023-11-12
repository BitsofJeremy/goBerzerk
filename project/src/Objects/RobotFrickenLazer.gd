extends RigidBody2D

# Robot Laser Object

signal robot_laser_hit

var explosion = preload("res://src/Objects/explosion.tscn")

func play_attack_sound():
  $AttackSound.play()

func _on_VisibilityNotifier2D_screen_exited():
	# When laser goes off the screen
	queue_free()

func _on_HitDetect_area_entered(area):
	# When Area Hits
	if area.is_in_group('enemies'):
		print("Robot Shot a robot, oops")
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		# Explode robot
		area.get_parent().dead()
		emit_signal("robot_laser_hit")

func _on_HitDetect_body_entered(body):
	# When Body hits
	if body.is_in_group("player"):
		print("Robot Shot the player")
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		emit_signal("robot_laser_hit")
		body.dead()
	elif body.is_in_group('walls'):
		print("Robot Shot a wall")
		queue_free()
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
