extends Area2D

var isInteractable: bool = false
var player : Player
var doorOpen : bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInteractable && player :
		if player.hasKey && !doorOpen:
			doorOpen = true
			$DoorSprite.play("door_open")
		elif doorOpen:
			if get_tree().get_current_scene().get_name() == "Game":
				get_tree().change_scene_to_file("res://levels/level_2.tscn")
			else: #^COPY THAT, REPLACE if's   == "[INSERT_NEXTLEVEL_NAME]" do that below here 
				print(get_tree().get_current_scene().get_name())
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
