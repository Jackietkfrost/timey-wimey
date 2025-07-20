class_name Fan extends Node2D

signal fan_timeshift(timeshift_type: String, timescale_new: int)

@onready var gust: AnimatedSprite2D = $AnimatedSprite2D
@onready var fan: AnimatedSprite2D = $Fan


@export var pushback_strength : Vector2 = Vector2 (70,0)

var player_ref
var timescale = 1
var is_touching = true
var angle : float

func _on_entered_gust(body: Node2D) -> void:
	if body is Player:	
		is_touching = true
		player_ref = body
		if (timescale != 0) :
			player_ref.velocity_modifier += pushback_strength.rotated(angle)

func _on_exited_gust(body: Node2D) -> void:
	if body is Player:
		is_touching = false
		if (timescale != 0) :
			player_ref.velocity_modifier -= pushback_strength.rotated(angle)

func _ready() :
	print(self.rotation_degrees)
	angle = deg_to_rad(rotation_degrees)
	gust.play("blow_wind")
	fan.play("default")
	

func _on_fan_timeshift(timeshift_type: String, timescale_new: int) -> void:
	if (timescale_new != 0 && timescale == 0 ) : #game unpaused
		if (player_ref && is_touching) :
			player_ref.velocity_modifier += pushback_strength.rotated(angle)
		gust.visible = true
	elif (timescale_new == 0 && timescale != 0): #game paused
		if (player_ref && is_touching) :
			player_ref.velocity_modifier -= pushback_strength.rotated(angle)
		gust.visible = false
	fan.play("default", timescale_new)
	gust.play("blow_wind", timescale_new)		
	timescale = timescale_new
