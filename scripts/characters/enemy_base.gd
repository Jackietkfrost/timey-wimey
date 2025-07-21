class_name Enemy_Base extends Path2D

signal timeshift()
@onready var path2d: PathFollow2D = $PathFollow2D
@onready var sprite: AnimatedSprite2D = $PathFollow2D/Enemy/AnimatedSprite2D


#@export var curve2d:Curve2D
@export var runSpeed:float = .2
@export_enum("walk", "fly") var enemy_type = "walk";
@export var canBePaused: bool = true

var timescale: float = 1

func _ready() -> void:
	sprite.play(enemy_type, timescale)

func _process(delta: float) -> void:
	path2d.progress_ratio += (runSpeed * timescale) * delta

func _on_timeshift(newTimescale:float) -> void:
	if canBePaused:
		timescale = newTimescale
		sprite.play(enemy_type, timescale)

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.died && !body.is_rewinding_self:
			body.player_rewinded.emit(true)
