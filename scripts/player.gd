class_name Player extends CharacterBody2D

signal entered_game(game_ref:Node2D)	

var gameInstance:Node2D
var rewind:bool = false

@export var speed:float = 100
@export var gravity:float = 30
@export var max_horizontal_speed:float = 100
@export var max_fall_speed:float = 200
@export var jump_force:float = 400

@onready var viewport:Viewport = get_viewport()


func _on_entered_game(game_ref: Node2D) -> void:
	gameInstance = game_ref
	print(gameInstance)
	

func _physics_process(_delta):
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = -jump_force
	
	var horizontal_direction:float = Input.get_axis("Move Left", "Move Right")
	velocity.x = speed * horizontal_direction
	if(horizontal_direction):
		if(horizontal_direction > 0):
			$Body.flip_h = false
		elif(horizontal_direction < 0):
			$Body.flip_h = true
		$Body.play("walk")
	elif(horizontal_direction == 0):
		$Body.play("idle")

	move_and_slide()

func _input(event:InputEvent):
	
	if event.is_action_pressed("Time"):
		var shockwave:ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
		var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
		/ Vector2(viewport.size)
		shockwave.set_shader_parameter("center", screenspace_player_pos)
		$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
		gameInstance.timeshift.emit("Pause")

	if event.is_action_pressed("Rewind"):
		if gameInstance:
			print(gameInstance)
			var shockwave:ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
			var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
			/ Vector2(viewport.size)
			shockwave.set_shader_parameter("center", screenspace_player_pos)
			$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
			gameInstance.timeshift.emit("Rewind")
