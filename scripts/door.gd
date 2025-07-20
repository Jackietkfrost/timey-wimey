extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var isInteractable: bool = false
var player: Player
var doorOpen: bool = false

func _ready() -> void:
	sprite.play("default")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && isInteractable && player:
		if player.hasKey && !doorOpen:
			doorOpen = true
			$DoorSprite.play("door_open")
		elif doorOpen:
			if get_tree().get_current_scene().get_name() == "Level 1":
				get_tree().change_scene_to_file("uid://cywhrka4sqcxv") # Level2
			elif get_tree().get_current_scene().get_name() == "Level2": # ^COPY THAT, REPLACE if's   == "[INSERT_NEXTLEVEL_NAME]" do that below here
				get_tree().change_scene_to_file("uid://fdiuab7kqqpa") # Level3
			elif get_tree().get_current_scene().get_name() == "Level3":
				get_tree().quit() # Quit lol
			else:
				print(get_tree().get_current_scene().get_name())
		pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		sprite.visible = true
		isInteractable = true
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		sprite.visible = false
		isInteractable = false
	pass # Replace with function body.
