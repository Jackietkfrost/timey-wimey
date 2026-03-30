class_name Player extends CharacterBody2D

signal entered_game(game_ref: Node2D)
signal player_rewinded(died: bool)

@export var speed: float = 100
@export var gravity: float = 30
@export var max_horizontal_speed: float = 100
@export var max_fall_speed: float = 200
@export var jump_force: float = 400
@export var side_jump_force: Vector2 = Vector2 (150, -400)
@export var hasKey: bool = false
@export var rewindDuration: float = 3.0
@export var velocity_modifier: Vector2 = Vector2(0, 0)

@onready var viewport: Viewport = get_viewport()
@onready var sprite: AnimatedSprite2D = $Body

var gameInstance: Node2D

var limited_rewind: bool = false
var full_rewind: bool = false

var history: Array[history_data]

class history_data 	:
	var sprite_direction: float
	var timescale: float
	var location : Vector2

var timescale: float = 1.0
var died: bool = false

var is_pausing : bool = false
var is_rewinding_world : bool = false
var is_rewinding_self : bool = false
var rewind_counter : int = 0

var last_jump : String = "None"
var is_wall_slidding : bool = false

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
		var horizontal_direction: float = Input.get_axis("Move Left", "Move Right")
		
		#Reset Jump state for walljump
		# velocity.y > 0 && is_on_wall() : resets jump state from "Up" to "None" if player does standing jump ah
		if is_on_floor() || ( velocity.y > 0 ):
			last_jump = "None"
		
		#Ignore movement input after walljump
		if (last_jump != "Left" && last_jump != "Right") :
			if horizontal_direction == 0 && !is_on_floor():
				pass
			else :
				velocity.x = (speed * horizontal_direction) + velocity_modifier.x
			
		_apply_gravity()
		
		_set_sprite(horizontal_direction)
		_save_player_history(position, horizontal_direction, -timescale)
		move_and_slide()

func _input(event: InputEvent):
	
	if not died:
		if event.is_action_pressed("Jump"):
			print (self.test_move(transform, Vector2 (0, 2)))
			_jump_function()
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

func _shockwave_effect(effect_name: String) -> void:
	var shockwave: ShaderMaterial = $Camera2D/CanvasLayer/ColorRect.material
	var screenspace_player_pos = viewport.get_canvas_transform() * self.position \
	/ Vector2(viewport.size)
	shockwave.set_shader_parameter("center", screenspace_player_pos)
	$Camera2D/CanvasLayer/AnimationPlayer.play(effect_name)

func _attempt_timeshift(new_timescale: float) -> void :
	if new_timescale != timescale :
		_shockwave_effect("shockwave")
		timescale = new_timescale
		gameInstance.timeshift.emit(new_timescale)
	
func _check_rewind_state() -> void :
	 # If limited position_history array is empty and we are doing a limited rewind, end the rewind
	if (limited_rewind && rewind_counter >= rewindDuration * 60 ):
		limited_rewind = false
		if not full_rewind :
			is_rewinding_self = false
			gameInstance.timeshift.emit(1)
			$Camera2D/CanvasLayer/CRT.visible = false

	# Else if the both the basic and full history array are empty and were were doing a full rewind
	# set rewind state to false
	if (full_rewind && history.is_empty()):
		full_rewind = false
		is_rewinding_self = false
		if died:
			died = false
			$Camera2D/CanvasLayer/CRT.visible = false
		gameInstance.timeshift.emit(1)

func _rewind_player() -> void :
	var rewind_speed = 2 if full_rewind else 1
	for n in rewind_speed:
		if !history.is_empty():
			var temp = history.pop_back()
			rewind_counter += 1
			_set_sprite(temp.sprite_direction)				
			position = temp.location
			gameInstance.timeshift.emit(-temp.timescale * rewind_speed)
			timescale= temp.timescale

func _save_player_history(player_position: Vector2, player_animation : float, _timescale_history : float) -> void :
	var temp : history_data = history_data.new()
	temp.location = player_position
	temp.sprite_direction = player_animation
	temp.timescale = timescale
	history.append(temp)
	if rewind_counter >= 0 :
		rewind_counter -= 1
	
func _clear_player_history():
	history.clear()
	print("Cleared player rewind history")
func _set_sprite (horizontal_direction : float) -> void :
	#If Character is on floor, set character to walking animations
	if is_on_floor() :
		sprite.play("walk")
		if (horizontal_direction > 0):
			sprite.flip_h = false
		elif (horizontal_direction < 0):
			sprite.flip_h = true
		elif (horizontal_direction == 0):
			sprite.play("idle")
	else:
		var touching_left : bool = self.test_move(transform, Vector2 (-2, 0))
		var touching_right : bool = self.test_move(transform, Vector2 (2, 0))
		
		#Set to wall hang sprite if touching left or right wall
		if touching_left :
			sprite.play("wall_hang")
			sprite.flip_h = true
		elif touching_right :
			sprite.play("wall_hang")
			sprite.flip_h = false
		
func _jump_function() -> void:
	var touching_left : bool = self.test_move(transform, Vector2 (-5, 0))
	var touching_right : bool = self.test_move(transform, Vector2 (5, 0))
	
	if is_on_floor():
		last_jump = "Up"
		velocity.y = -jump_force
		AudioPlayer.play_FX(preload("uid://cf3nwdxda6als"))	
		move_and_slide()
	elif touching_left && last_jump != "Left":
		last_jump = "Left"
		velocity = Vector2 ( side_jump_force.x, side_jump_force.y )
		move_and_slide()
	elif touching_right && last_jump != "Right":	
		last_jump = "Right"
		velocity = Vector2 ( -side_jump_force.x, side_jump_force.y )	
		move_and_slide()

func _apply_gravity() -> void:
		#Ignores gravity when affected by fans or when jumping
		if velocity_modifier.y == 0 || last_jump == "None":
			if is_on_wall_only() && last_jump != "Up": #Wall slide	
				sprite.play("wall_hang")
				velocity.y += gravity/8
				if velocity.y > max_fall_speed/3:
					velocity.y = max_fall_speed/3
			else:	
				sprite.play("fall")
				velocity.y += gravity
				if velocity.y > max_fall_speed:
					velocity.y = max_fall_speed
	
