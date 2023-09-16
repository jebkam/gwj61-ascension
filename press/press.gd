extends GPUParticles2D

@onready var timer := $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	
func _on_timeout():
	queue_free()
