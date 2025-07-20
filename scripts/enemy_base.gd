class_name Enemy_Base extends Path2D

signal timeshift()
@onready var path2d: PathFollow2D = $PathFollow2D
@onready var sprite: AnimatedSprite2D = $PathFollow2D/Enemy/AnimatedSprite2D


#@export var curve2d:Curve2D
@export var runSpeed:float = .2
@export var isFlying:bool = false
@export var canBePaused: bool = false

var timescale: float = 1

func _ready() -> void:
	#self.curve2D = curve2d
	if timescale > 0:
		if isFlying:
			sprite.play("fly")
			pass
		else:
			sprite.play("walk")

func _process(delta: float) -> void:
	if timescale > 0:
		sprite.play()
	if timescale == 0:
		sprite.stop()
	path2d.progress_ratio += (runSpeed * timescale) * delta


func _on_timeshift(timeshift_type: String, newTimescale:float) -> void:
	if canBePaused:
		timescale = newTimescale


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.died:
			body.player_rewinded.emit(true)
