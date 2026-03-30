extends Control
@onready var main_menu_panel: PanelContainer = $MainMenuPanel
@onready var audio_menu_panel: PanelContainer = $AudioMenuPanel
@onready var level_grid_panel: PanelContainer = $LevelGridPanel

@onready var Master_BUS_ID = AudioServer.get_bus_index("Master")
@onready var Music_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var scene_transition: AnimationPlayer = $Scene_Transition.get_node("%trans_player")



func _on_start_game_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.animation_finished.emit(get_tree().change_scene_to_file("uid://dh5t46h13p0vc"))
	

func _on_level_select_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.play("fade_out")
	show_levelselect_menu()
	$LevelGridPanel/MarginContainer/GridContainer/Level1Button.grab_focus()

func _on_audio_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.play("fade_out")
	show_audio_menu()
	$AudioMenuPanel/AudioPanel/MasterSlider.grab_focus()


func _on_quit_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().quit()


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Master_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(Master_BUS_ID, value < .05)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Music_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(Music_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


func _on_back_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.play("fade_out")
	audio_menu_panel.visible = false
	main_menu_panel.visible = true
	$MainMenuPanel/VBoxContainer/StartGameButton.grab_focus()

func show_audio_menu():
	audio_menu_panel.visible = true
	main_menu_panel.visible = false

func show_levelselect_menu():
	level_grid_panel.visible = true
	main_menu_panel.visible = false


func _on_back_from_level_select_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.play("fade_out")
	level_grid_panel.visible = false
	main_menu_panel.visible = true
	$MainMenuPanel/VBoxContainer/StartGameButton.grab_focus()


func _on_level_1_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	scene_transition.play("fade_out")
	get_tree().change_scene_to_file("uid://dh5t46h13p0vc")


func _on_level_2_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("uid://cywhrka4sqcxv")


func _on_level_3_button_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("uid://fdiuab7kqqpa")

func _on_ready() -> void:
	$MainMenuPanel/VBoxContainer/StartGameButton.grab_focus()
