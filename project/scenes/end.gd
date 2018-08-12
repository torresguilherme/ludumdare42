extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		global.changeScene(2)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
