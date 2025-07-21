extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pause_container: PanelContainer = $PausePanelContainer
@onready var pause_menu: CanvasLayer = $".."
@onready var audio_panel: PanelContainer = $AudioMenuPanel
@onready var Master_BUS_ID = AudioServer.get_bus_index("Master")
@onready var Music_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

func _ready():
	$AudioMenuPanel/AudioPanel/MasterSlider.value = \
	AudioServer.get_bus_volume_linear(Master_BUS_ID)
	$AudioMenuPanel/AudioPanel/MusicSlider.value = \
	AudioServer.get_bus_volume_linear(Music_BUS_ID)
	$AudioMenuPanel/AudioPanel/SFXSlider.value = \
	AudioServer.get_bus_volume_linear(SFX_BUS_ID)
	hide_all_menus()

func resume():
	get_tree().paused = false
	hide_all_menus()
	animation_player.play_backwards("blur")
	await animation_player.animation_finished

func pause():
	show_pause_menu()
	animation_player.play("blur")
	get_tree().paused = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()

func _on_resume_button_pressed() -> void:
	resume()

func _on_options_button_pressed() -> void:
	show_audio_menu()

func _on_back_button_pressed() -> void:
	audio_panel.visible = false
	pause_menu.visible = true
	
func _on_restart_button_pressed() -> void:
	await resume()
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Master_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(Master_BUS_ID, value < .05)
	pass # Replace with function body.

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Music_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(Music_BUS_ID, value < .05)
	pass # Replace with function body.
	
func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
	pass # Replace with function body.

#pause_menu.visible = true

func hide_all_menus():
	pause_menu.visible = false
	audio_panel.visible = false

func show_pause_menu():
	visible = true
	pause_menu.visible = true

func show_audio_menu():
	pause_menu.visible = false
	audio_panel.visible = true


func _on_return_2_main_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("uid://cfskcc5ogdwsp")
