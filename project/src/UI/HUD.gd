extends MarginContainer

onready var life_counter = [
	$main/LifeCounter/L1,
#	$main/LifeCounter/L2,
#	$main/LifeCounter/L3
	]

func _on_Player_life_changed(value):
	print("Player lives remaining:")
	print(life_counter.size())
	for icon in range(life_counter.size()):
		life_counter[icon].visible = value > icon

func _on_score_changed(_points):
	GameState.current_score += _points
	$main/ScoreBox/ScoreLabel.text = str(GameState.current_score)
