extends Node

var PLAYER_GROUP = "player"
var ENEMY_GROUP = "enemy"
var currentScene = 0
var scenes = []

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -8)
	scenes.append(load('res://scenes/story.tscn'))
	scenes.append(load('res://scenes/controls.tscn'))
	scenes.append(load('res://scenes/main.tscn'))
	scenes.append(load('res://scenes/end.tscn'))
	pass

func nextScene():
	currentScene += 1
	get_tree().change_scene_to(scenes[currentScene])

func changeScene(value):
	currentScene = value
	get_tree().change_scene_to(scenes[currentScene])