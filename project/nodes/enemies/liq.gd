extends KinematicBody2D

var hp = 7
var lastShot = 0
var shotCooldown = .15
onready var damageAnim = $"damage-anim"
onready var damageSound = $"damage-sound"
onready var deathSound = $"death-sound"
var bullet = preload('res://nodes/enemies/liq-bullet.tscn')

func _ready():
	add_to_group(global.ENEMY_GROUP)
	randomize()

func _process(delta):
	if lastShot <= 0:
		shoot()
		lastShot = shotCooldown
	else:
		lastShot -= delta

func shoot():
	var newBullet = bullet.instance()
	newBullet.position = position
	newBullet.direction = Vector2(randf() - 0.5, randf() - 1.7).normalized()
	$"../".add_child(newBullet)
	$shoot.play()

func takeDamage(value):
	if hp > 0:
		hp -= value
		if hp <= 0:
			damageAnim.play("death")
			deathSound.play()
		else:
			damageAnim.play("damage")
			damageSound.play()