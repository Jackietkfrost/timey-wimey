extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_damaging: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player && is_damaging:		
		var player:Player = body
		player.player_rewinded.emit(true)

func _on_body_near(body: Node2D) -> void:
	sprite.play("active")
	AudioPlayer.play_FX(preload("uid://c4kusyufnc2ug"))
	is_damaging = true

func _on_body_exited(body: Node2D) -> void:
	sprite.play("default")
	
	is_damaging = false
