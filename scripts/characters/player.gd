class_name Player extends CharacterBody2D

signal entered_game(game_ref: Node2D)
signal player_rewinded(died: bool)

@export var speed: float = 100
@export var gravity: float = 30
@export var max_horizontal_speed: float = 100
@export var max_fall_speed: float = 200
@export var jump_force: float = 400
@export var side_jump_force: float = 350
@export var time_stop_amt: float = 2
@export var time_rewind_amt: float = 2
@export var hasKey: bool = false
@export var rewindDuration: float = 3.0
@export var velocity_modifier: Vector2 = Vector2(0, 0)

@onready var viewport: Viewport = get_viewport()
@onready var sprite: AnimatedSprite2D = $Body

var gameInstance: Node2D
var limited_rewind: bool = false
var full_rewind: bool = false
var position_history: Array[Vector2]
var position_history_full: Array[Vector2]
var direction_history: Array[float]
var timeshift_history: Array[float] = [1.0]
var timescale: float = 1.0
var died: bool = false
var paused: bool = false

var is_pausing : bool = false
var is_rewinding_world : bool = false
var is_rewinding_self : bool = false

func _on_entered_game(game_ref: Node2D) -> void:
	gameInstance = game_ref

func _physics_process(_delta):
	
	#check if history arrays have run out
	_check_rewind_state()
	
	#if player is rewinding self then rewind player instead of physics process
	if is_rewinding_self :
		_rewind_player()
		
	#if player isn't rewinding himself or dead
	elif not died:
		
		#Disables gravity when player is being pushed by fan
		if velocity_modifier.y == 0:
			velocity.y += gravity
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
		else:
			velocity.y = velocity_modifier.y + gravity
		
		if Input.is_action_just_pressed("Jump"):
			_jump_function()
			
		var horizontal_direction: float = Input.get_axis("Move Left", "Move Right")
		velocity.x = (speed * horizontal_direction) + velocity_modifier.x
		
		_set_sprite_direction(horizontal_direction)
		_save_player_history(position, horizontal_direction, -timescale)
		move_and_slide()

func _input(event: InputEvent):
	
	if not died:
		if event.is_action_pressed("Time"):
			is_pausing = true
			_attempt_timeshift(0)
			
		if event.is_action_pressed("Rewind"):
			is_rewinding_world = true
			_attempt_timeshift(-1)
				
		if event.is_action_pressed("Player_Rewind"):
			is_rewinding_self = true
			limited_rewind = true
			_attempt_timeshift(-1)
			
		if event.is_action_released("Rewind") && is_rewinding_world:
			is_rewinding_world = false
			if not is_rewinding_self && not is_pausing :
				_attempt_timeshift(1)
			
		if event.is_action_released("Time"):
			is_pausing = false
			if not is_rewinding_self && not is_rewinding_world :
				_attempt_timeshift(1)
				
		if event.is_action_released("Player_Rewind"):
			is_rewinding_self = false
			if not is_rewinding_self && not is_pausing :
				_attempt_timeshift(1)
		
func _on_player_rewinded(playerDied: bool) -> void:
	
	if (playerDied):
		died = true
		gameInstance.timeshift.emit(0)
		sprite.play("die")
		AudioPlayer.play_FX(preload("uid://cr1qnrf5rpsmc"))
		await get_tree().create_timer(2, true, true, false).timeout
		$Camera2D/CanvasLayer/CRT.visible = true
		
	full_rewind = true
	is_rewinding_self = true

func _shockwave_effect(name: String) -> void:
	var shockwave: ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
	var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
	/ Vector2(viewport.size)
	shockwave.set_shader_parameter("center", screenspace_player_pos)
	$Camera2D/CanvasLayer/AnimationPlayer.play(name)
	#shockwave.set_shader_parameter("center", screenspace_player_pos)
	#$Camera2D/CanvasLayer/AnimationPlayer.play("shockwave-end")

func _attempt_timeshift(new_timescale: float) -> void :
	if new_timescale != timescale :
		_shockwave_effect("shockwave")
		timescale = new_timescale
		gameInstance.timeshift.emit(new_timescale)
	
func _check_rewind_state() -> void :
	 # If limited position_history array is empty and we are doing a limited rewind, end the rewind
	if (limited_rewind && position_history.is_empty()):
		limited_rewind = false
		if not full_rewind :
			is_rewinding_self = false
			gameInstance.timeshift.emit(1)
			$Camera2D/CanvasLayer/CRT.visible = false

	# Else if the both the basic and full history array are empty and were were doing a full rewind
	# set rewind state to false
	if (full_rewind && position_history_full.is_empty() && position_history.is_empty()):
		full_rewind = false
		is_rewinding_self = false
		gameInstance.timeshift.emit(1)
		if died:
			died = false
			$Camera2D/CanvasLayer/CRT.visible = false

func _rewind_player() -> void :
	var newDirection
	var rewind_speed: int = 1	
	if full_rewind:
		rewind_speed = 2

	for n in rewind_speed:		
		#Set the direction
		if !direction_history.is_empty():
			newDirection = direction_history.pop_back()
			if (newDirection > 0):
				$Body.flip_h = false
			elif (newDirection < 0):
				$Body.flip_h = true
			$Body.play("walk")
			if (newDirection == 0):
				$Body.play("idle")
				
		#Set position
		if !position_history.is_empty():
			position = position_history.pop_back()
		elif !position_history_full.is_empty():
			position = position_history_full.pop_back()
		
		#Set timescale
		if !timeshift_history.is_empty():
			var new_timescale = timeshift_history.pop_back()
			gameInstance.timeshift.emit(new_timescale * rewind_speed)
			timescale=new_timescale

func _save_player_history(player_position: Vector2, player_animation : float, timescale_history : float) -> void :

	if (rewindDuration * 60 == position_history.size()):
		position_history_full.append(position_history.pop_front())
	position_history.append(player_position)
	timeshift_history.append(timescale_history)
	direction_history.append(player_animation)
	
func _set_sprite_direction (horizontal_direction : float) -> void :
		if (horizontal_direction > 0):
			$Body.flip_h = false
		elif (horizontal_direction < 0):
			$Body.flip_h = true
			$Body.play("walk")
		elif (horizontal_direction == 0):
			$Body.play("idle")

func _jump_function() -> void:
	if is_on_floor():
		velocity.y = - jump_force
		AudioPlayer.play_FX(preload("uid://cf3nwdxda6als"))
	#elif is_on_wall() && !has_jumped:
	#	for i in range(get_slide_collision_count()):
	#		var collision = get_slide_collision(i)
	#		var normal = collision.get_normal()
	#		has_jumped = true
	#		if normal.x < 0:
	#			velocity = Vector2 ( -side_jump_force/2, -side_jump_force )
	#		elif normal.x > 0:
	#			velocity = Vector2 ( side_jump_force/2, -side_jump_force )
	
	
