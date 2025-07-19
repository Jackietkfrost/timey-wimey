extends Area2D

var isInteractable: bool = false
var player : Player

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInteractable && player:
		if player.hasKey:
			$DoorSprite.play("door_open")
		pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		isInteractable = true
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		isInteractable = false
	pass # Replace with function body.
