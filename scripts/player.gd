class_name Player extends CharacterBody2D

signal entered_game(game_ref: Node2D)
signal player_rewinded(died:bool)

@export var speed: float = 100
@export var gravity: float = 30
@export var max_horizontal_speed: float = 100
@export var max_fall_speed: float = 200
@export var jump_force: float = 400
@export var side_jump_force: float = 350
@export var time_stop_amt: float = 2
@export var time_rewind_amt: float = 2
@export var hasKey:bool = false
@export var rewindDuration : float = 3.0
@export var velocity_modifier : Vector2 = Vector2 (0,0)

@onready var viewport: Viewport = get_viewport()
@onready var sprite: AnimatedSprite2D = $Body

var gameInstance: Node2D
var rewind: bool = false
var full_rewind: bool = false
var rewind_self : bool = false
var position_history : Array[ Vector2 ]
var position_history_full : Array[ Vector2 ]
var direction_history : Array [ float ]
var timeshift_history : Array [float] = [1.0]
var timescale : float = 1.0
var died: bool = false
var paused: bool = false
var has_jumped = false

func _on_entered_game(game_ref: Node2D) -> void:
	gameInstance = game_ref

func _physics_process(_delta) :
	if ( position_history.is_empty() && rewind) :
		rewind = false
		rewind_self = false
		gameInstance.timeshift.emit("Resume", 1)		
	elif (position_history_full.is_empty() && position_history.is_empty() && full_rewind  ):
		full_rewind = false
		rewind_self = false
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
			if !timeshift_history.is_empty() :
				gameInstance.timeshift.emit("Pause", timeshift_history.pop_back())
	elif not died:
		if (rewindDuration * 60 == position_history.size()) :	
			position_history_full.append(position_history.pop_front())
		if position:	
			position_history.append( position )	
			timeshift_history.append(paused)

		
		if velocity_modifier.y == 0 :
			velocity.y += gravity
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
		else :
			velocity.y = velocity_modifier.y + gravity
		
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor():
				has_jumped = false
				velocity.y = -jump_force
				AudioPlayer.play_FX(preload("uid://cf3nwdxda6als"))
			elif is_on_wall():
				for i in range(get_slide_collision_count()):
					var collision = get_slide_collision(i)
					var normal = collision.get_normal()
					has_jumped = true
					if normal.x < 0:
						velocity = Vector2 ( -side_jump_force/2, -side_jump_force )
					elif normal.x > 0:
						velocity = Vector2 ( side_jump_force/2, -side_jump_force )

		var horizontal_direction:float = Input.get_axis("Move Left", "Move Right")

		if is_on_floor() :
			velocity.x = ( speed * horizontal_direction ) + velocity_modifier.x
			
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
		_shockwave_effect()
		timescale = 0
		gameInstance.timeshift.emit("Pause", 0)

	if event.is_action_pressed("Rewind"):
		_shockwave_effect()
		timescale = -1
		gameInstance.timeshift.emit("Rewind", -1)
			
	if event.is_action_pressed("Player_Rewind") && (rewindDuration * 60 == position_history.size()) :
		timescale = -2
		gameInstance.timeshift.emit("Rewind", -2)
		rewind= true
		rewind_self = true	
		
	if event.is_action_released("Full_Rewind") :
		gameInstance.timeshift.emit("Resume", 1)
		timescale = 1
		self.full_rewind = false
		rewind_self = false
		
	if event.is_action_released("Rewind") && timescale == -1:
		gameInstance.timeshift.emit("Resume", 1)
		timescale = 1
		
	if event.is_action_released("Time") && timescale == 0:
		paused = false
		gameInstance.timeshift.emit("Resume", 1)
		timescale = 1
		
func _on_player_rewinded(playerDied: bool) -> void:
	gameInstance.timeshift.emit("Pause", 0)
	print(playerDied)
	if (playerDied):
		died = true
		sprite.play("die")
		AudioPlayer.play_FX(preload("uid://cr1qnrf5rpsmc"))
		await get_tree().create_timer(2, true, true, false).timeout
		$Camera2D/CanvasLayer/CRT.visible = true
	full_rewind = true
	rewind_self = true
	gameInstance.timeshift.emit("Rewind", -2)

func _shockwave_effect() ->  void :
	var shockwave:ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
	var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
	/ Vector2(viewport.size)
	shockwave.set_shader_parameter("center", screenspace_player_pos)
	$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave")
	shockwave.set_shader_parameter("center", screenspace_player_pos)
	$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave-end")
