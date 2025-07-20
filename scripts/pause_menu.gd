extends Control

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func PauseInput():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()

func _on_resume_button_pressed() -> void:
	resume()
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	
	pass # Replace with function body.

func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit

func _process(delta):
	PauseInput()
