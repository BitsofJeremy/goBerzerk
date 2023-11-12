extends Node

func _ready():
	var path = "res://src/UI/TitleScreen.tscn"
	var map = load(path).instance()
	add_child(map)
