# Droplet.gd
extends CharacterBody2D

signal droplet_ascended

@onready var particles := $GPUParticles2D
@onready var algae := $Algae

@onready var ascension_sound := $Ascension_Sound
@onready var hurt_sound := $Hurt_Sound
@onready var pickup_sound := $Pickup_Sound


var gravity = 60
var movement_force = -120
var push_force = 60

var is_algae_fully_grown = false

func _ready():
	add_to_group("droplets")
	
func _process(delta):
	velocity.y += gravity * delta
	move_and_slide()

	# Screen wrapping
	var screen_size = Vector2(640, 640)
	if global_position.x > screen_size.x:
		global_position.x = 0
	elif global_position.x < 0:
		global_position.x = screen_size.x

	if global_position.y < 0 and not is_algae_fully_grown:
		velocity.y += -movement_force

	if algae.scale.x >= scale.x:
		is_algae_fully_grown = true
		
	if is_algae_fully_grown:
		ascension()
	
func apply_movement(press_position):
	# Check vertical position of press
	if press_position.y < global_position.y:
		velocity.y += -movement_force  # Droplet should sink
		particles.process_material.gravity.y = -movement_force
	else:
		velocity.y += movement_force  # Droplet should rise
		particles.process_material.gravity.y = movement_force
	# Check horizontal position of press
	if press_position.x < global_position.x:
		velocity.x += push_force  # Move right
		particles.process_material.gravity.x = push_force
	else:
		velocity.x += -push_force  # Move left
		particles.process_material.gravity.x = -push_force

func pop():
	queue_free()
	
func ascension():
	velocity.y += movement_force 	
	ascension_sound.play()
	await(ascension_sound.finished)
	if global_position.y < 0:
		emit_signal("droplet_ascended")
		pop()
	
