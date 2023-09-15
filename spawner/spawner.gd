# Spawner.gd
extends Node2D

signal apply_score
signal apply_time(extra_time)

@onready var nutrient_timer := $Nutrient_Timer
@onready var droplet_timer := $Droplet_Timer
@onready var hazard_timer := $Hazard_Timer
@onready var nutrient_scene := preload("res://nutrient/nutrient.tscn")
@onready var droplet_scene := preload("res://droplet/droplet.tscn")
@onready var hazard_scene := preload("res://hazard/hazard.tscn")

const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1920

# Minimum and maximum time to spawn

@export var nutrient_wait_range = Vector2(1.0, 3.0)
@export var droplet_wait_range = Vector2(10.0, 30.0)
@export var hazard_wait_range = Vector2(30.0, 60.0)
@export var nutrient_extra_time = 3
@export var ascension_extra_time = 10

var nutrients_collected : int
var droplets_ascended : int

func _ready():
	randomize()
	# Connect the nutrient_timer's timeout signal to the function to spawn the nutrient
	nutrient_timer.timeout.connect(_on_nutrient_timeout)
	droplet_timer.timeout.connect(_on_droplet_timeout)
	hazard_timer.timeout.connect(_on_hazard_timeout)
	# Start the nutrient_timer with a random time between nutrient_min_time and nutrient_max_time
	set_random_timer(nutrient_timer, nutrient_wait_range.x, nutrient_wait_range.y)
	set_random_timer(droplet_timer, droplet_wait_range.x, droplet_wait_range.y) 
	set_random_timer(hazard_timer, hazard_wait_range.x, hazard_wait_range.y) 
	spawn_droplet()

func set_random_timer(timer, min_time, max_time):
	timer.stop()  # Stop the nutrient_timer if it's currently running
	var random_time = randf_range(min_time, max_time)
	timer.wait_time = random_time
	timer.start()

func _on_nutrient_timeout():
	spawn_nutrient()
	set_random_timer(nutrient_timer, nutrient_wait_range.x, nutrient_wait_range.y)  # Reset the nutrient_timer with another random value
	
func _on_droplet_timeout():
	spawn_droplet()
	set_random_timer(droplet_timer, droplet_wait_range.x, droplet_wait_range.y) 
	pass
	
func _on_hazard_timeout():
	spawn_hazard()
	set_random_timer(hazard_timer, hazard_wait_range.x, hazard_wait_range.y) 
	pass

func spawn_nutrient():
	# Your logic to spawn the nutrient goes here
	var nutrient = nutrient_scene.instantiate()
	# Get screen dimensions
	var screen_size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	# Generate random coordinates within the screen dimensions
	var random_x = randf_range(0, screen_size.x)
	var random_y = randf_range(0, screen_size.y)
	# Set the nutrient's position to the random coordinates
	nutrient.position = Vector2(random_x, random_y)
	add_child(nutrient)
	nutrient.nutrient_collected.connect(_on_nutrient_collected)


func spawn_droplet():
	var droplet = droplet_scene.instantiate()
	droplet.position = Vector2(randf_range(0, SCREEN_WIDTH), randf_range(0, SCREEN_HEIGHT))
	add_child(droplet)
	droplet.droplet_ascended.connect(_on_droplet_ascended)

# Function to propagate the signal to the Game node
func _on_nutrient_collected():
	nutrients_collected += 1
	emit_signal("apply_score")
	emit_signal("apply_time", nutrient_extra_time)  # Emit new signal to add extra time
	
func _on_droplet_ascended():
	droplets_ascended += 1
	emit_signal("apply_score")
	emit_signal("apply_time", ascension_extra_time)  # Emit new signal to add extra time


func spawn_hazard():
	var hazard = hazard_scene.instantiate()
	hazard.position = Vector2(randf_range(0, SCREEN_WIDTH), randf_range(0, SCREEN_HEIGHT))
	add_child(hazard)
	pass
