extends Node2D

var checkpoint = Vector2()

func _ready():
	pass

func pause():
	get_tree().paused = true

func nextScene():
	global.nextScene()