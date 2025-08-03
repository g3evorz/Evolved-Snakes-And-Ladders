extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("fade_in")

func _on_credit_button_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/credit.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
