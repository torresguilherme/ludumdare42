extends KinematicBody2D

var hp = 50
var maxHp = 50
var speed = 600
onready var player = $"../player"
onready var damageAnim = $"damage-anim"
onready var damageSound = $"damage-sound"
onready var deathSound = $"death-sound"

# attacks
enum states{BARRAGE, ROLL, BOUNCE}
var current = BARRAGE
var cooldown1 = .05
var lastShot = 0
var barrageDuration = 3
var timeInBarrage = 0
var bullet = preload("res://nodes/enemies/bread.tscn")

#roll
var distanceMoved = 0
var fullDistance = 900
var direction = Vector2()

# bounce
var gravity = 1000
var ySpeed = 0
var initialYSpeed = -500

func _ready():
	randomize()
	add_to_group(global.ENEMY_GROUP)
	set_process(false)

func _process(delta):
	# attack
	if current == BARRAGE:
		if lastShot <= 0:
			shootBread()
			lastShot = cooldown1
		else:
			lastShot -= delta
		timeInBarrage += delta
		if timeInBarrage >= barrageDuration:
			current = randi()%2+1
			timeInBarrage = 0
	elif current == ROLL:
		if !distanceMoved:
			$run.play()
			if player.global_position.x < global_position.x:
				direction = Vector2(-1, 0)
			else:
				direction = Vector2(1, 0)
		move_and_collide(direction * speed * delta)
		distanceMoved += speed * delta
		if distanceMoved > fullDistance:
			distanceMoved = 0
			current = BARRAGE
	else:
		if !distanceMoved:
			$run.play()
			ySpeed = initialYSpeed
			if player.global_position.x < global_position.x:
				direction = Vector2(-1, 0)
			else:
				direction = Vector2(1, 0)
		move_and_collide(direction * speed * delta)
		move_and_collide(Vector2(0, ySpeed) * delta)
		ySpeed += gravity * delta
		distanceMoved += speed * delta
		if distanceMoved > fullDistance:
			distanceMoved = 0
			ySpeed = 0
			current = BARRAGE

func shootBread():
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
			$"../scene-anim".play("win")
		else:
			damageAnim.play("damage")
			damageSound.play()

func _on_bossarea_body_entered(body):
	if body.is_in_group(global.PLAYER_GROUP):
		$"../CanvasLayer/boss-info".visible = true
		set_process(true)

func _on_bossarea_body_exited(body):
	if body.is_in_group(global.PLAYER_GROUP):
		$"../CanvasLayer/boss-info".visible = false
		set_process(false)
