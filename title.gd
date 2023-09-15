extends Control

@onready var button := $MarginContainer/VBoxContainer/Play_Button
@onready var game_scene := preload("res://game.tscn")

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	get_tree().change_scene_to_packed(game_scene)
