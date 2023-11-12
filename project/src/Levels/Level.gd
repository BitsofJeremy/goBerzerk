extends Node2D

signal score_changed

# Environment Objects
var DoorWay = preload("res://src/Objects/DoorWay.tscn")
# Characters
var Player = preload("res://src/Player/Player.tscn")
var Robot = preload("res://src/Enemies/Robot.tscn")
var EvilOtto = preload("res://src/Enemies/EvilOtto.tscn")

onready var objects = $Objects
onready var environment = $Environment
onready var HUD = $CanvasLayer/HUD

#var level_color = Color(1.0,1.0,1.0,1.0)
var level_color

func _ready():
	randomize()
	var level_color = GameState.colors[randi() % len(GameState.colors)]
	print(level_color)
	$CanvasLayer/HUD/main/ScoreBox/ScoreLabel.text = str(GameState.current_score)
	objects.hide()
	spawn_objects()
	spawn_doorways()

func spawn_objects():
	# for loop to go through tilemap and assign objects
	for cell in objects.get_used_cells():
		var id = objects.get_cellv(cell)
		var type = objects.tile_set.tile_get_name(id)
		match type:
			'player':
				var pos = objects.map_to_world(cell, true)
				$Player.position =  pos/2
				$Player.visible = true
			'robot':
				var r = Robot.instance()
				var pos = objects.map_to_world(cell, true)
				add_child(r)
				r.robot_color = level_color
				r.position = pos/2
				r.connect("robot_dead", $CanvasLayer/HUD, '_on_score_changed')
#				r.set_color(level_color)

func spawn_doorways():
	for cell in environment.get_used_cells():
		var id = environment.get_cellv(cell)
		var type = environment.tile_set.tile_get_name(id)
		match type:
			'door':
				var door = DoorWay.instance()
				var pos = objects.map_to_world(cell, true)
				add_child(door)
				door.position = pos/2
				print(door.position)

func spawn_evilotto():
	# for loop to go through tilemap and assign objects
	print("Oh Snap! Here comes EvilOtto!")
	for cell in objects.get_used_cells():
		var id = objects.get_cellv(cell)
		var type = objects.tile_set.tile_get_name(id)
		match type:
			'evil_otto':
				var eo = EvilOtto.instance()
				var pos = objects.map_to_world(cell, true)
				add_child(eo)
				eo.position = pos/2
				eo.connect("killed_player", self, 'otto_kill')

func _on_Player_dead():
	GameState.restart()

func otto_kill():
	print("PLAYER DEAD")
	$Player.dead()

func _on_EvilOttoTimer_timeout():
	spawn_evilotto()
