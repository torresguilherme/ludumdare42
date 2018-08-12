extends Area2D

func _ready():
	pass


func _on_checkpoint_body_entered(body):
	if body.is_in_group(global.PLAYER_GROUP):
		$"../../../".checkpoint = global_position
