class_name MovingPlatforms extends Path2D

signal platform_timeshift(timeshift_type: String, timescale_new : int)

var timescale = 1

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$PathFollow2D/RemoteTransform2D.update_position = true
	self.speed_scale = 1 * timescale
	self.speed = 2 * timescale
	$AnimationPlayer.active = true
	animation.speed_scale = speed_scale
	path.progress += speed

func _on_platform_timeshift(_timeshift_type: String, timescale_new: int) -> void:
	timescale = timescale_new
