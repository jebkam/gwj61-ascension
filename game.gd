# Game.gd
extends Node2D

@onready var spawner := $Spawner
@onready var game_timer := $Game_Timer

@onready var press_sound := $Press_Sound
@onready var bgm := $BG/BGM
@onready var ui := $UI

@onready var press_scene := preload("res://press/press.tscn")
@onready var title_scene := preload("res://title.tscn")

var score = 0
var scale_factor = Vector2(1, 1)
var game_over = false

# Variables to hold your counts and sizes
var nutrients_collected = 0  # Increment this each time you collect a nutrient
var algae_size = 1  # Update this based on your algae's size (perhaps it starts at 1)
var droplets_ascended = 0  # Increment this each time a droplet ascends

# Multipliers
var nutrient_multiplier = 10
var algae_multiplier = 5
var droplet_multiplier = 20
var time_left = 0

func _ready():
	spawner.apply_score.connect(calculate_score)
	spawner.apply_time.connect(add_extra_time)  # New signal connection for adding extra time
	game_timer.timeout.connect(_on_game_over)
	game_timer.start()
	bgm.play()

	


func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var transformed_position = Vector2(
			event.global_position.x * scale_factor.x,
			event.global_position.y * scale_factor.y
		)
		
		if event.pressed:
			var press = press_scene.instantiate()
			press.position = transformed_position
			add_child(press)
			press_sound.play()
			await(press_sound.finished)
			for droplet in get_tree().get_nodes_in_group("droplets"):
				droplet.apply_movement(transformed_position)

func _process(delta):
	nutrients_collected = spawner.nutrients_collected
	droplets_ascended = spawner.droplets_ascended
	# Update the score display
	score = calculate_score()
	ui.score_label.text = "Score: " + str(score)

	if not game_over:
		time_left = game_timer.time_left  # Update time_left based on the actual timer
		ui.time_left_label.text = "Time: " + str(int(time_left))
		if get_tree().get_nodes_in_group("droplets").size() == 0:
			spawner.spawn_droplet()

func calculate_score() -> int:
	# Your existing scoring logic
	var score = (nutrients_collected * nutrient_multiplier) + (algae_size * algae_multiplier) + (droplets_ascended * droplet_multiplier)
	return score
	
# New function to add extra time to the game timer
func add_extra_time(extra_time: int):
	time_left += extra_time  # Add the extra time
	game_timer.stop()  # Stop the timer
	game_timer.wait_time = time_left  # Set the new wait time
	game_timer.start()  # Start the timer again
	
func _on_game_over():
	game_over = true
	ui.header_label.visible = true
	ui.header_label.text = "Game Over"
	ui.replay_button.visible = true
	ui.quit_button.visible = true
	spawner.droplet_timer.stop()
	spawner.hazard_timer.stop()
	spawner.nutrient_timer.stop()	


