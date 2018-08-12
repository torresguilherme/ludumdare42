extends VBoxContainer

func _ready():
	pass

func _on_retry_toggled(button_pressed):
	var player = $"../../player"
	player.hp = player.maxHp
	player.global_position = $"../../".checkpoint
	$retry.pressed = false
	visible = false
	get_tree().paused = false

func _on_quit_toggled(button_pressed):
	get_tree().quit()
