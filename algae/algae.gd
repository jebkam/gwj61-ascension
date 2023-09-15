# Algae.gd
extends Sprite2D

@onready var growth = scale.x

func grow():
	growth += 0.75
	scale = Vector2(growth, growth)
