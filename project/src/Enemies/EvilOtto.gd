extends Area2D

# Evil Otto Object
# Chases player and Chirps
signal killed_player

var speed = 50
var velocity = Vector2()


func _chirp():
#	print("Chirp Playing:")
	$chirp.stream = GameState.eo_chirps[GameState.eo_chirp_len - 1]
	$chirp.play()

func _ready():
	randomize()
	GameState.eo_chirp_len = len(GameState.eo_chirps)
	$AnimationPlayer.play("default")
	_chirp()

func _process(delta):
	GameState.eo_chirp_len = randi() % len(GameState.eo_chirps)
	if GameState.player != null:
		velocity = global_position.direction_to(
			GameState.player.global_position
		)
	global_position += velocity * speed * delta
	position += velocity * delta

func _on_ChirpTimer_timeout():
	_chirp()

func _on_EvilOtto_body_entered(body):
	if body.is_in_group('player'):
		print('Otto emit signal: killed_player')
		emit_signal("killed_player")
