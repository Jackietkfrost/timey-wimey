class_name Enemy_Base extends CharacterBody2D

@onready var patrol_path: Path2D = $AnimatedSprite2D/Path2D
@onready var follow_path: PathFollow2D = $Path2D/PathFollow2D

#var curr_point: Vector2 = patrol_path.curve.get
var curr_point: Vector2 = follow_path.progress

func give_path() -> void:
	patrol_path.curve.get_point_position(1)
