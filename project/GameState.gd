extends Node

var num_levels = 8
var current_level = 1
var current_score = 0
var player = null

var chirp_len = 0
var eo_chirp_len = 0

# Multipliers
# To speed up the enemies on level completion
var eo_speed_up = 0.8
var robot_speed_up = 0.8
var robot_bullet_speed_up = 0.5

var title_screen = "res://src/UI/TitleScreen.tscn"

# Top and Bottom exits
var level_tb_01 = "res://src/Levels/Level_tb_01.tscn"
var level_tb_02 = "res://src/Levels/Level_tb_02.tscn"
var level_tb_03 = "res://src/Levels/Level_tb_03.tscn"
var level_tb_04 = "res://src/Levels/Level_tb_04.tscn"

# Top Left Right exits
var level_tlr_01 = "res://src/Levels/Level_tlr_01.tscn"
var level_tlr_02 = "res://src/Levels/Level_tlr_02.tscn"

# Bottom Left Right exits
var level_blr_01 = "res://src/Levels/Level_blr_01.tscn"
var level_blr_02 = "res://src/Levels/Level_blr_02.tscn"

var all_levels = [
	level_tb_01, level_tb_02, level_tb_03, level_tb_04,
	level_blr_01, level_blr_02, level_tlr_01, level_tlr_02
]

# Chirpy Robots
var chirp_alert = preload("res://assets/sounds/robot_sounds/alert.wav")
var chirp_attack = preload("res://assets/sounds/robot_sounds/attack.wav")
var chirp_attack_the_humanoid = preload("res://assets/sounds/robot_sounds/attack_the_humanoid.wav")
var chirp_charge = preload("res://assets/sounds/robot_sounds/charge.wav")
var chirp_chicken = preload("res://assets/sounds/robot_sounds/chicken.wav")
var chirp_destroy = preload("res://assets/sounds/robot_sounds/destroy.wav")
var chirp_fight_like_a_robot = preload("res://assets/sounds/robot_sounds/fight_like_a_robot.wav")
var chirp_humanoid_detected = preload("res://assets/sounds/robot_sounds/humanoid_detected.wav")
var chirp_intruder = preload("res://assets/sounds/robot_sounds/intruder.wav")
var chirp_get_the_humanoid = preload("res://assets/sounds/robot_sounds/get_the_humanoid.wav")

var robot_chirps = [
	chirp_alert, 
	chirp_attack,
	chirp_charge,
	chirp_chicken,
	chirp_destroy,
	chirp_fight_like_a_robot,
	chirp_intruder
]

var eo_chirps = [
	chirp_get_the_humanoid,
	chirp_humanoid_detected,
	chirp_attack_the_humanoid
]

# Colors for robots
# Got link to get different colors
# https://docs.godotengine.org/en/3.1/classes/class_color.html

var red = Color(1.0, 0.0, 0.0)
var blue = Color( 0, 0, 1, 1 )
var aliceblue = Color( 0.94, 0.97, 1, 1 )
var cyan = Color( 0, 1, 1, 1 )
var gold = Color( 1, 0.84, 0, 1 )
var green = Color( 0, 1, 0, 1 )
var hotpink = Color( 1, 0.41, 0.71, 1 )
var lightseagreen = Color( 0.13, 0.7, 0.67, 1 )
var mintcream = Color( 0.96, 1, 0.98, 1 )

var colors = [red, blue, aliceblue, cyan, gold, gold, green, hotpink, lightseagreen, mintcream]
# var color = colors[randi() % len(colors)]
# robot.set_color(color)

func restart():
	current_score = 0
	current_level = 1
	get_tree().change_scene(title_screen)

# TODO setup random levels if Top, Bottom, Left, Right
func next_level():
	# Add 1 to current level var
	current_level += 1
	var next_level_index = randi() % num_levels
	print(all_levels[next_level_index - 1])
	get_tree().change_scene(all_levels[next_level_index - 1])

