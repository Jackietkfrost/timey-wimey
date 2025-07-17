extends CharacterBody2D

@export var speed = 100
@export var gravity = 30
@export var max_horizontal_speed = 100
@export var max_fall_speed = 200
@export var jump_force = 400

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > max_fall_speed :
			velocity.y = max_fall_speed
	
	if Input.is_action_just_pressed("Jump"):
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("Move Left", "Move Right")
	velocity.x = speed * horizontal_direction
	if(horizontal_direction > 0):
		$Body.flip_h = false
		$Body.play("walk")
	elif(horizontal_direction < 0):
		$Body.flip_h = true
		$Body.play("walk")
	else: 
		$Body.play("idle")
		
	move_and_slide()
