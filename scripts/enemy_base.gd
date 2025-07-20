class_name Enemy_Base extends PathFollow2D

signal timeshift()

@export var runSpeed:float = 20

func _process(delta: float) -> void:
	set_progress(get_progress() * runSpeed * delta)
