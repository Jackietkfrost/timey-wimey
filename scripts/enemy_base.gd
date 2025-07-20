class_name Enemy_Base extends Path2D

signal timeshift()

@onready var patrol_path: Path2D = $AnimatedSprite2D/Path2D
@onready var follow_path: PathFollow2D = $Path2D/PathFollow2D
