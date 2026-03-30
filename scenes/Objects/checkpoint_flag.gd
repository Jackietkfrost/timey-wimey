extends Area2D

var player_ref : Player
var is_open: bool
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player && not is_open:
		player_ref = body
		player_ref._clear_player_history()
		animation.play("flag_popup")
		is_open = true
		
	
		
func loop_flag():
	animation.play("flag_movement")


func _on_animated_sprite_2d_animation_finished() -> void:
	animation.play("flag_movement")
