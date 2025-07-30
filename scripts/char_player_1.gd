extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	if global.player_is_move:
		sprite.play("walk")
		global.button_state = false
	else:
		sprite.play("idle")
