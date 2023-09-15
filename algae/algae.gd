# Algae.gd
extends Sprite2D

@onready var growth = scale.x

func grow():
	growth += 0.25
	scale = Vector2(growth, growth)
