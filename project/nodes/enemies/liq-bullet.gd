extends Area2D

var direction = Vector3()
var damage = 2
var speed = 600

func _ready():
	pass

func _process(delta):
	position += direction * speed * delta
	direction.y += delta * 10
	direction = direction.normalized()

func _on_liqbullet_body_entered(body):
	if body.is_in_group(global.PLAYER_GROUP):
		body.takeDamage(damage)
	if !body.is_in_group(global.ENEMY_GROUP):
		queue_free()
