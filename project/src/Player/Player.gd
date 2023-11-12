extends KinematicBody2D

signal life_changed
signal dead

enum {IDLE, RUN, DEAD, SHOOT}
enum {RIGHT, LEFT, UP, DOWN}

export (int) var run_speed = 350
var state
var anim
var new_anim
var velocity = Vector2()
var life = 1

# Laser stuff
var FRICKEN_LAZER = preload("res://src/Objects/FrickenLazer.tscn")
var direction
var can_fire = true
export var bullet_speed = 1000
export var fire_rate = 0.2

func _ready():
	GameState.player = self
	change_state(IDLE)

func start(pos):
	position = pos
	show()
	life = 1
	emit_signal('life_changed', life)
	change_state(IDLE)

func change_state(new_state):
	state = new_state
#	print("State changing to: ", state)
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		DEAD:
			new_anim = 'dead'
			$DeadScream.play()
			yield(get_tree().create_timer(1.49), 'timeout')
			emit_signal('dead')

func dead():
	change_state(DEAD)
	
func shoot(direction):
	var laser = FRICKEN_LAZER.instance()
	match direction:
		RIGHT:
			print("Firing Laser:  RIGHT")
			$AnimatedSprite.play('shoot')
			$AnimatedSprite.flip_h = false
			laser.play_attack_sound()
			laser.position = $FacingRight.get_global_position()
			laser.rotation_degrees = rotation_degrees
			laser.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		LEFT:
			print("Firing Laser:  LEFT")
			$AnimatedSprite.play('shoot')
			$AnimatedSprite.flip_h = true
			laser.play_attack_sound()
			laser.position = $FacingLeft.get_global_position()
			laser.rotation_degrees = rotation_degrees + 180
			laser.apply_impulse(Vector2(), Vector2(-bullet_speed, 0).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		UP:
			print("Firing Laser:  UP")
			$AnimatedSprite.play('shoot')
			laser.play_attack_sound()
			laser.position = $FacingUp.get_global_position()
			laser.rotation_degrees = rotation_degrees + -90
			laser.apply_impulse(Vector2(), Vector2(0, -bullet_speed).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		DOWN:
			print("Firing Laser:  DOWN")
			$AnimatedSprite.play('shoot')
			laser.play_attack_sound()
			laser.position = $FacingDown.get_global_position()
			laser.rotation_degrees = rotation_degrees + 90
			laser.apply_impulse(Vector2(), Vector2(0, bullet_speed).rotated(rotation))
			get_tree().get_root().add_child(laser)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true

func get_input():
	if state == DEAD:
		return

	velocity = Vector2()
	if Input.is_action_pressed("right"):
		direction = RIGHT
		change_state(RUN)
		$AnimatedSprite.flip_h = false
		velocity.x += 1
		
	if Input.is_action_pressed("left"):
		direction = LEFT
		change_state(RUN)
		$AnimatedSprite.flip_h = true
		velocity.x -= 1

	if Input.is_action_pressed("down"):
		direction = DOWN
		change_state(RUN)
		velocity.y += 1
		
	if Input.is_action_pressed("up"):
		direction = UP
		change_state(RUN)
		velocity.y -= 1
		
	velocity = velocity.normalized() * run_speed

	if state == RUN and velocity == Vector2.ZERO:
		change_state(IDLE)

	# Spacebar or controller
	# Shoot the FRICKEN_LAZER
	if Input.is_action_just_pressed('shoot') and can_fire:
		state = SHOOT
		shoot(direction)


func _physics_process(delta):
	get_input()
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite.play(anim)
	velocity = move_and_slide(velocity)
	if state == DEAD:
		return

	# For movement collisions
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider is TileMap:
			print("# player ran into wall")
			# player ran into wall
			dead()

		if collision.collider.is_in_group('enemies'):
			print("# Player ran into enemy")
			# Player ran into enemy
			dead()
