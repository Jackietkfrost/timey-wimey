class_name Enemy_Base extends Path2D

signal timeshift()
@onready var path2d: PathFollow2D = $PathFollow2D
@onready var sprite: AnimatedSprite2D = $PathFollow2D/Enemy/AnimatedSprite2D

@export var curve2D:Curve2D
@export var runSpeed:float = .5

var timescale: float = 1
var isPaused: bool = false

func _ready() -> void:
	if timescale > 0:
		sprite.play("walk")

func _process(delta: float) -> void:
	if timescale > 0:
		path2d.progress_ratio += (runSpeed * timescale) * delta


func _on_timeshift(timeshift_type: String, newTimescale:float) -> void:
	print("Timeshifted?!")
	timescale = newTimescale
