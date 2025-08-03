extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("fade_in")

func _on_back_button_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
