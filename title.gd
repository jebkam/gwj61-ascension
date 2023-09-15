extends Control

@onready var button := $MarginContainer/VBoxContainer/Play_Button
@onready var game_scene := preload("res://game.tscn")
@onready var button_sound := $Button_Sound

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	button_sound.play()  # Play the button sound
	await(button_sound.finished)  # Wait for the sound to finish
	get_tree().change_scene_to_packed(game_scene)
