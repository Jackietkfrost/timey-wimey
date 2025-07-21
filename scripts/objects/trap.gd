class_name Trap extends Area2D

signal trap_timeshift(timeshift_type: String, timescale_new: int)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_active: bool = false
var is_touching : bool = false
var is_in_range: bool = false
var timescale: int = 1
var player_ref : Player

func _on_body_entered(body: Node2D) -> void:
	is_touching = true
	if body is Player && is_active:		
		player_ref = body
		if !player_ref.died:
			player_ref.player_rewinded.emit(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_touching = false


func _on_body_near(body: Node2D) -> void:
	if body is Player :
		is_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player :
		is_in_range = false

func _on_trap_timeshift(_timeshift_type: String, timescale_new: int) -> void:
	timescale = timescale_new

func _process(_delta: float) -> void:
	if(timescale != 0) :
		if is_in_range && !is_active :
			sprite.play("active")
			AudioPlayer.play_FX(preload("uid://c4kusyufnc2ug"))
			is_active=true
			if is_touching && player_ref && !player_ref.died:
				player_ref.player_rewinded.emit(true)
		elif (is_active && !is_in_range) :
			sprite.play("default")
			is_active=false
		
