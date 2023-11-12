extends KinematicBody2D

signal robot_dead

enum {IDLE, WALK, WALK_DOWN, WALK_UP, DEAD, SHOOT}
enum {RIGHT, LEFT, UP, DOWN}

var SPEED = 20
var HP = 1
var POINTS = 10
var velocity
var walk_dir
var state
var anim
var new_anim
var robot_color

# Laser stuff
var FRICKEN_LAZER = preload("res://src/Objects/RobotFrickenLazer.tscn")
var direction
var can_fire = true
export var bullet_speed = 150
export var fire_rate = 0.8

func _ready():
	randomize()
	GameState.chirp_len = len(GameState.robot_chirps)
	set_color(robot_color)
	print(robot_color)
	var direction = randi() % 4
	change_state(WALK)
	walk_dir = direction
	walk_it(direction)

func change_state(new_state):
	state = new_state
#	print("State changing to: ", state)
	match state:
		IDLE:
			new_anim = 'idle'
		WALK:
			new_anim = 'walk_left'
		WALK_DOWN:
			new_anim = 'walk_down'
		WALK_UP:
			new_anim = 'walk_up'
		DEAD:
			new_anim = 'dead'
			set_physics_process(false)
		SHOOT:
			new_anim = 'idle'

func shoot(direction):
	var laser = FRICKEN_LAZER.instance()
	laser.set_color(robot_color)
	match direction:
		RIGHT:
#			print("Robot Firing Laser:  RIGHT")
			laser.play_attack_sound()
			laser.position = $FacingRight.get_global_position()
			laser.rotation_degrees = rotation_degrees
			laser.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			$chirp.stream = GameState.robot_chirps[GameState.chirp_len - 1]
			$chirp.play()
			can_fire = true
		LEFT:
#			print("Robot Firing Laser:  LEFT")
			laser.play_attack_sound()
			laser.position = $FacingLeft.get_global_position()
			laser.rotation_degrees = rotation_degrees + 180
			laser.apply_impulse(Vector2(), Vector2(-bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			$chirp.stream = GameState.robot_chirps[GameState.chirp_len - 1]
			$chirp.play()
			can_fire = true
		UP:
#			print("Robot Firing Laser:  UP")
			laser.play_attack_sound()
			laser.position = $FacingUp.get_global_position()
			laser.rotation_degrees = rotation_degrees + -90
			laser.apply_impulse(Vector2(), Vector2(0, -bullet_speed).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		DOWN:
#			print("Robot Firing Laser:  DOWN")
			laser.play_attack_sound()
			laser.position = $FacingDown.get_global_position()
			laser.rotation_degrees = rotation_degrees + 90
			laser.apply_impulse(Vector2(), Vector2(0, bullet_speed).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true

func walk_it(direction):
	if state == DEAD:
		return

	velocity = Vector2()
	if direction == RIGHT:
		change_state(WALK)
		walk_dir = direction
		$AnimatedSprite.flip_h = true
		velocity.x += 1

	if direction == LEFT:
		change_state(WALK)
		walk_dir = direction
		$AnimatedSprite.flip_h = false
		velocity.x -= 1

	if direction == DOWN:
		change_state(WALK_DOWN)
		walk_dir = direction
		velocity.y += 1

	if direction == UP:
		change_state(WALK_UP)
		walk_dir = direction
		velocity.y -= 1

	velocity = velocity.normalized() * SPEED

	if state == WALK and velocity == Vector2.ZERO:
		change_state(IDLE)

func _process(delta):
	if state == DEAD:
		return
	GameState.chirp_len = randi() % len(GameState.robot_chirps)
	# Select random direction to walk
	if $RightWallDetect.is_colliding():
#		print("Hit the right wall")
		var direction = LEFT
		walk_dir = direction
		walk_it(direction)

	if $LeftWallDetect.is_colliding():
#		print("Hit the left wall")
		var direction = RIGHT
		walk_dir = direction
		walk_it(direction)

	if $TopWallDetect.is_colliding():
#		print("Hit the top wall")
		var direction = DOWN
		walk_dir = direction
		walk_it(direction)

	if $BottomWallDetect.is_colliding():
#		print("Hit the bottom wall")
		var direction = UP
		walk_dir = direction
		walk_it(direction)
		
	#### Player Detection ####

	if $PlayerDetectRight.is_colliding():
#		print("Robot Sees player:  RIGHT")
		var direction = RIGHT
		walk_dir = direction
		walk_it(direction)
		if can_fire:
			shoot(direction)
		else:
			walk_it(direction)

	if $PlayerDetectLeft.is_colliding():
#		print("Robot Sees player:  LEFT")
		var direction = LEFT
		walk_dir = direction
		walk_it(direction)
		if can_fire:
			shoot(direction)
		else:
			walk_it(direction)

	if $PlayerDetectUp.is_colliding():
#		print("Robot Sees player:  UP")
		var direction = UP
		walk_dir = direction
		walk_it(direction)
		if can_fire:
			shoot(direction)
		else:
			walk_it(direction)

	if $PlayerDetectDown.is_colliding():
#		print("Robot Sees player:  DOWN")
		var direction = DOWN
		walk_dir = direction
		walk_it(direction)
		if can_fire:
			shoot(direction)
		else:
			walk_it(direction)

func _physics_process(delta):
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite.play(anim)
	if state == DEAD:
		return
	velocity = move_and_slide(velocity)

func set_color(_color):
	$AnimatedSprite.modulate = _color

func dead():
	HP -= 1
	if HP <= 0:
		if state == DEAD:
			return
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("robot_dead", POINTS)
		$AnimatedSprite.play('dead')
		$explode.play()
		set_physics_process(false)
		$Timer.start()
		change_state(DEAD)

func _on_Timer_timeout():
	queue_free()
