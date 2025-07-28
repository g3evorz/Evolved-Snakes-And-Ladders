extends Node2D

@onready var sprite = $Path2D/PathFollow2D/AnimatedSprite2D
func _ready():
	sprite.play("Idle")
