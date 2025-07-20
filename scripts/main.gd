extends Node2D

var player_ref : Node2D
var moving_platform_ref : Node2D
var trap_ref : Area2D

signal timeshift(timeshift_type : String, timescale : int)

func _ready() -> void:
	AudioPlayer.play_music_level()

func _on_child_entered_tree(node: Node) -> void:
	print("Child entered: " + str(node.name))
	if node is Player:
		player_ref = node
		player_ref.entered_game.emit(self)
	if node is MovingPlatforms:
		moving_platform_ref = node
	if node is Trap:
		trap_ref = node

func _on_timeshift(timeshift_type : String, timescale : int) -> void:
	if moving_platform_ref:
		moving_platform_ref.platform_timeshift.emit(timeshift_type, timescale)
	if trap_ref :
		trap_ref.trap_timeshift.emit(timeshift_type, timescale)
