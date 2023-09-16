extends Control

@onready var header_label := $Margin/VBox/Header_Box/Header_Label
@onready var replay_button := $Margin/VBox/Button_Box/Replay_Button
@onready var quit_button := $Margin/VBox/Button_Box/Quit_Button
@onready var button_sound := $Button_Sound
@onready var score_label := $Margin/VBox/HUD_Box/Score_Label
@onready var time_left_label := $Margin/VBox/HUD_Box/Time_Left_Label

@onready var title_scene := preload("res://title.tscn")
@onready var game_scene := preload("res://main.tscn")

func _ready() -> void:
	header_label.visible = false
	replay_button.visible = false
	quit_button.visible = false
	replay_button.pressed.connect(_on_replay_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_replay_button_pressed():
	button_sound.play()
	await(button_sound.finished)
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed():
	button_sound.play()
	await(button_sound.finished)
	get_tree().change_scene_to_packed(title_scene)
