class_name Fan extends Node2D

signal fan_timeshift(timeshift_type: String, timescale_new: int)

@onready var gust: AnimatedSprite2D = $AnimatedSprite2D
@onready var fan: AnimatedSprite2D = $Fan

@export var fan_strength : float = 70
@export var pushback_strength : Vector2

var player_ref
var timescale = 1
var is_touching = false
var is_exerting = false

func _on_entered_gust(body: Node2D) -> void:
	if body is Player:	
		is_touching = true
		player_ref = body
		if (!player_ref.rewind_self) :
			is_exerting = true
			player_ref.velocity_modifier += pushback_strength * timescale

func _on_exited_gust(body: Node2D) -> void:
	if body is Player:
		is_touching = false
		if (is_exerting) :
			is_exerting = false
			player_ref.velocity_modifier -= pushback_strength * timescale

func _ready() :
	var angle = deg_to_rad(self.rotation_degrees)
	pushback_strength = ( Vector2 (fan_strength, 0) ).rotated(angle)
	gust.play("blow_wind")
	fan.play("default")

func _on_fan_timeshift(_timeshift_type: String, timescale_new: int) -> void:
	if (timescale_new != 0 && timescale == 0 ) : #game unpaused
		gust.visible = true
	elif (timescale_new == 0 && timescale != 0): #game paused
		gust.visible = false

	if (player_ref && is_touching) :
		if ( is_exerting ) :
			player_ref.velocity_modifier -= pushback_strength * timescale
			is_exerting = false
			
		if ( !player_ref.rewind_self ) :
			player_ref.velocity_modifier += pushback_strength * timescale_new
			is_exerting = true
		
	fan.play("default", timescale_new)
	gust.play("blow_wind", timescale_new)	
	timescale = timescale_new
