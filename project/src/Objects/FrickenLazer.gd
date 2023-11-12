extends RigidBody2D

# Player Laser object

var explosion = preload("res://src/Objects/explosion.tscn")

func play_attack_sound():
  $AttackSound.play()

func _on_VisibilityNotifier2D_screen_exited():
	# When laser goes off the screen
	queue_free()

func _on_HitDetect_area_entered(area):
	# When Area Hits
	if area.is_in_group("enemies"):
		print("Player Shot a robot")
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		area.get_parent().dead()
	else:
		print("Laser hit something else?")

func _on_HitDetect_body_shape_entered(body_id, body, body_shape, local_shape):
	# When Body hits
	if body.is_in_group('walls'):
		print("Player Shot a wall")
		queue_free()
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		
