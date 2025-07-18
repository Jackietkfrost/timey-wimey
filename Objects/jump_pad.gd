extends StaticBody2D
@export var jumpHeight:float = 500
@export var jumpDistance:float = 200
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var jumpDirection = -1 if sprite_2d.flip_h else 1
		body.velocity = Vector2(jumpDistance * jumpDirection, -jumpHeight)
		sprite_2d.play("default")
	print("Object collided!" + str(body))
