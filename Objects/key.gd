extends Area2D

@onready var interactable: Area2D = $Interactable
var isInteractable: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInteractable:
		self.queue_free()
		pass
#func _ready() -> void:
	#interactable.interact = _on_interact

func _on_interact():
	interactable.is_interactable = false
	print("key picked up")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		isInteractable = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		isInteractable = false
	pass # Replace with function body.
