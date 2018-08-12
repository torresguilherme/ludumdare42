extends Area2D

var direction = Vector3()
var damage = 1
var reach = 800
var speed = 600
var distance = 0

var blast = preload('res://nodes/player/blast.tscn')

func _ready():
	pass

func _process(delta):
	position += direction * delta * speed
	distance += speed * delta
	if distance > reach:
		queue_free()

func _on_playerbullet_body_entered(body):
	if body.is_in_group(global.ENEMY_GROUP):
		body.takeDamage(damage)
	if !body.is_in_group(global.PLAYER_GROUP):
		var newBlast = blast.instance()
		newBlast.position = position
		$"../".add_child(newBlast)
		queue_free()
