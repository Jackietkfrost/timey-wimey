extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_damaging: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player && is_damaging:
		body.sprite.play("die")
		get_tree().create_timer(2, true, true, true).timeout
		body.player_rewinded.emit()


func _on_body_near(body: Node2D) -> void:
	sprite.play("default")
	is_damaging = true

func _on_body_exited(body: Node2D) -> void:
	sprite.play_backwards("default")
	is_damaging = false
