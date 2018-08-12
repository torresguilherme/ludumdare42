extends KinematicBody2D

var hp = 4
onready var player = $"../../player"
onready var damageAnim = $"damage-anim"
onready var damageSound = $"damage-sound"
onready var deathSound = $"death-sound"
var seesPlayer = false
var inReach = false
var reach = 400

#shooting
var bullet = preload('res://nodes/enemies/pan-bullet.tscn')
var lastShot = 0
var shotCooldown = 1

func _ready():
	add_to_group(global.ENEMY_GROUP)

func _process(delta):
	if global_position.distance_to(player.global_position) <= reach:
		inReach = true
	else:
		inReach = false
		seesPlayer = false
	if inReach:
		var vision = get_world_2d().direct_space_state.intersect_ray(global_position, player.global_position, [self])
		if !vision.empty():
			if vision.collider.is_in_group(global.PLAYER_GROUP):
				seesPlayer = true
			else:
				seesPlayer = false
	if seesPlayer:
		if lastShot <= 0:
			shoot(player.global_position)
			lastShot = shotCooldown
	if lastShot > 0:
		lastShot -= delta

func shoot(targetPosition):
	var newBullet = bullet.instance()
	newBullet.direction = (targetPosition - global_position).normalized()
	newBullet.global_position = global_position
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