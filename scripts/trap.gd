class_name Trap extends Area2D

signal trap_timeshift(timeshift_type: String, timescale_new: int)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_active: bool = false
var is_in_range: bool = false
var timescale: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player && is_active:		
		var player:Player = body
		if !player.full_rewind :
			player.player_rewinded.emit(true)

func _on_body_near(body: Node2D) -> void:
	if body is Player :
		print("is near")
		is_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player :
		print("is not near")
		is_in_range = false

func _on_trap_timeshift(timeshift_type: String, timescale_new: int) -> void:
	timescale = timescale_new

func _process(delta: float) -> void:
	if(timescale != 0) :
		if is_in_range && !is_active :
			sprite.play("active")
			is_active=true
		elif (is_active && !is_in_range) :
			sprite.play("default")
			is_active=false
		
	
