extends KinematicBody2D

# balance
var maxHp = 10
var hp
var invTime = 1
var invincible = 0

# movement
var speed = 400
var gravity = 1000
var ySpeed = 0
var initJumpSpeed = -600
var maxYspeed = 600

# shooting
var facingDirection = Vector2(1, 0)
var bullet = preload('res://nodes/player/player-bullet.tscn')
var shotCooldown = .2
var lastShot = 0

# animation
enum states{IDLE, WALK, JUMP, FALL, SHOOT}
var currentState = IDLE
onready var anim = $anim

func _ready():
	hp = maxHp
	add_to_group(global.PLAYER_GROUP)

func _process(delta):
	# moving
	currentState = IDLE
	var direction = 0
	if Input.is_action_pressed("walk-left"):
		direction -= 1
	if Input.is_action_pressed("walk-right"):
		direction += 1
	if direction:
		facingDirection = Vector2(direction, 0)
		currentState = WALK
	move_and_slide(Vector2(direction * speed, ySpeed), Vector2(0, -1))
	if Input.is_action_just_pressed("jump") && is_on_floor():
		ySpeed = initJumpSpeed
		$sfx/jump.play()
	if !is_on_floor():
		ySpeed += gravity * delta
		if ySpeed > maxYspeed:
			ySpeed = maxYspeed
		if ySpeed < 0:
			currentState = JUMP
		else:
			currentState = FALL
	
	# shooting
	if Input.is_action_pressed("shoot") && lastShot <= 0:
		shoot()
		lastShot = shotCooldown
		currentState = SHOOT
	if lastShot > 0:
		lastShot -= delta
	
	# animation
	if !anim.current_animation == "shoot-right" && !anim.current_animation == "shoot-left":
		if currentState == IDLE:
			if facingDirection.x == 1:
				if !anim.current_animation == "idle-right":
					anim.play("idle-right")
			else:
				if !anim.current_animation == "idle-left":
					anim.play("idle-left")
		elif currentState == WALK:
			if facingDirection.x == 1:
				if !anim.current_animation == "walk-right":
					anim.play("walk-right")
			else:
				if !anim.current_animation == "walk-left":
					anim.play("walk-left")
		elif currentState ==  JUMP:
			if facingDirection.x == 1:
				if !anim.current_animation == "jump-right":
					anim.play("jump-right")
			else:
				if !anim.current_animation == "jump-left":
					anim.play("jump-left")
		elif currentState == FALL:
			if facingDirection.x == 1:
				if !anim.current_animation == "fall-right":
					anim.play("fall-right")
			else:
				if !anim.current_animation == "fall-left":
					anim.play("fall-left")
		else:
			if facingDirection.x  == 1:
				anim.play('shoot-right')
			else:
				anim.play("shoot-left")
	
	if invincible > 0:
		invincible -= delta

func shoot():
	var newBullet = bullet.instance()
	newBullet.direction = facingDirection
	newBullet.position = position + facingDirection * 10
	$"../".add_child(newBullet)
	$sfx/shoot.play()

func takeDamage(value):
	if hp > 0 && invincible <= 0:
		invincible = invTime
		$sfx/hurt.play()
		hp -= value
		if hp <= 0:
			$"../scene-anim".play("game-over")
		else:
			$"damage-anim".play("damage")