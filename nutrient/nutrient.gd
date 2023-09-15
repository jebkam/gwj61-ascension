# nutrient.gd
extends Area2D

signal nutrient_collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("droplets"):
		body.algae.grow()
		emit_signal("nutrient_collected")
		queue_free()
