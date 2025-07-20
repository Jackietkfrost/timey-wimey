class_name Player extends CharacterBody2D

signal entered_game(game_ref: Node2D)
signal player_rewinded(died:bool)

@export var speed: float = 100
@export var gravity: float = 30
@export var max_horizontal_speed: float = 100
@export var max_fall_speed: float = 200
@export var jump_force: float = 400
@export var time_stop_amt: float = 2
@export var time_rewind_amt: float = 2
@export var hasKey:bool = false
@export var rewindDuration : float = 3.0
@export var velocity_modifier : Vector2 = Vector2 (0,0)

@onready var viewport: Viewport = get_viewport()
@onready var sprite: AnimatedSprite2D = $Body

var gameInstance: Node2D
var rewind: bool
var full_rewind: bool
var position_history : Array[ Vector2 ]
var position_history_full : Array[ Vector2 ]
var direction_history : Array [ float ]
var pause_history : Array [bool]
var died: bool = false
var paused: bool = false

func _on_entered_game(game_ref: Node2D) -> void:
	gameInstance = game_ref

func _physics_process(_delta) :
	if ( position_history.is_empty() && rewind) :
		rewind = false
		gameInstance.timeshift.emit("Resume", 1)		
	elif (position_history_full.is_empty() && position_history.is_empty() && full_rewind  ):
		full_rewind = false
		gameInstance.timeshift.emit("Resume", 1)
		if died:
			died = false
		$Camera2D/CanvasLayer/CRT.visible = false

	if rewind == true || full_rewind == true:
		var newDirection
		var rewind_speed : int = 1
		if full_rewind :
			rewind_speed = 2
		for n in rewind_speed :
			if !direction_history.is_empty() :
				newDirection = direction_history.pop_back()
				if(newDirection > 0):
					$Body.flip_h = false
				elif(newDirection < 0):
					$Body.flip_h = true
				$Body.play("walk")
				if(newDirection == 0):
					$Body.play("idle")
			if !position_history.is_empty():
				position = position_history.pop_back()
			elif !position_history_full.is_empty() :
				position = position_history_full.pop_back()
			if !pause_history.is_empty() :
				var wasPaused = pause_history.pop_back()
				if paused != wasPaused :
					if paused :
						gameInstance.timeshift.emit("Resume", 1)
					else :
						gameInstance.timeshift.emit("Pause", 0)
	elif not died:
		if (rewindDuration * 60 == position_history.size()) :	
			position_history_full.append(position_history.pop_front())
		if position:	
			position_history.append( position )	
			pause_history.append(paused)

		
		if velocity_modifier.y == 0 :
			velocity.y += gravity
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
		else :
			velocity.y = velocity_modifier.y + gravity
		
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor():
				velocity.y = -jump_force
				AudioPlayer.play_FX(preload("uid://cf3nwdxda6als"))
		
		var horizontal_direction:float = Input.get_axis("Move Left", "Move Right")

		velocity.x = ( speed * horizontal_direction ) + velocity_modifier.x
		if position:
			direction_history.append(horizontal_direction)
		if(horizontal_direction):
			if(horizontal_direction > 0):
				$Body.flip_h = false
			elif(horizontal_direction < 0):
				$Body.flip_h = true
			$Body.play("walk")
		elif(horizontal_direction == 0):
			$Body.play("idle")
		move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("Time"):
		var shockwave: ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
		var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
		/ Vector2(viewport.size)
		shockwave.set_shader_parameter("center", screenspace_player_pos)
		$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
		paused = true
		gameInstance.timeshift.emit("Pause", 0)

	if event.is_action_pressed("Rewind"):
		var shockwave: ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
		var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
		/ Vector2(viewport.size)
		shockwave.set_shader_parameter("center", screenspace_player_pos)
		$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
		gameInstance.timeshift.emit("Rewind", -1)
		#self.rewind = true	
			
	if event.is_action_pressed("Player_Rewind") && (rewindDuration * 60 == position_history.size()) :
		var shockwave:ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
		var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
		/ Vector2(viewport.size)
		shockwave.set_shader_parameter("center", screenspace_player_pos)
		$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
		shockwave.set_shader_parameter("center", screenspace_player_pos)
		$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave-end")
		gameInstance.timeshift.emit("Rewind", -2)
		self.full_rewind = true	
		
	if event.is_action_released("Full_Rewind") :
		gameInstance.timeshift.emit("Resume", 1)
		self.full_rewind = false
	if event.is_action_released("Rewind") :
		gameInstance.timeshift.emit("Resume", 1)
		#self.rewind = false
	if event.is_action_released("Time") :
		paused = false
		gameInstance.timeshift.emit("Resume", 1)
		
func _on_player_rewinded(playerDied: bool) -> void:
	gameInstance.timeshift.emit("Pause", 0)
	print(playerDied)
	if (playerDied):
		died = true
		sprite.play("die")
		AudioPlayer.play_FX(preload("uid://cr1qnrf5rpsmc"))
		await get_tree().create_timer(2, true, true, false).timeout
		$Camera2D/CanvasLayer/CRT.visible = true
	self.full_rewind = true
	gameInstance.timeshift.emit("Rewind", -2)
