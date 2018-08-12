extends Container

onready var player = $"../../player"

func _ready():
	pass

func _process(delta):
	$Label.text = "HP " + str(player.hp) + "/" + str(player.maxHp)
	$TextureProgress.max_value = player.maxHp
	$TextureProgress.value = player.hp
