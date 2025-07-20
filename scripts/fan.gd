class_name Fan extends Node2D

signal trap_timeshift(timeshift_type: String, timescale_new: int)

@onready var gust: AnimatedSprite2D = $AnimatedSprite2D
@onready var fan: AnimatedSprite2D = $Fan


@export var pushback_strength : Vector2 = Vector2 (70,0)

var timescale = 1
var is_active = true
var angle : float

func _on_entered_gust(body: Node2D) -> void:
	if body is Player && is_active:	
		print(angle)
		print( pushback_strength.rotated(angle))	
		var player_ref : Player = body
		
		player_ref.velocity_modifier += pushback_strength.rotated(angle)

func _on_exited_gust(body: Node2D) -> void:
	if body is Player && is_active:		
		var player_ref : Player = body
		player_ref.velocity_modifier -= pushback_strength.rotated(angle)

func _ready() :
	print(self.rotation_degrees)
	angle = deg_to_rad(rotation_degrees)
	gust.play("blow_wind")
	fan.play("default")
