extends Area2D

@onready var prompt: AnimatedSprite2D = $Prompt

var isInteractable: bool = false
var player : Player

func _ready() -> void:
	prompt.play("e_prompt")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInteractable && player:
		player.hasKey = true
		self.queue_free()
		pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		prompt.visible = true
		isInteractable = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		prompt.visible = false
		isInteractable = false
	pass # Replace with function body.
