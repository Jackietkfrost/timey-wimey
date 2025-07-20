extends Node2D

var player_ref : Node2D
var moving_platform_ref : Array = []
var trap_ref : Array = []
var fan_ref : Array = []

signal timeshift(timeshift_type : String, timescale : int)

func _ready() -> void:
	AudioPlayer.play_music_level()

func _on_child_entered_tree(node: Node) -> void:
	print("Child entered: " + str(node.name))
	if node is Player:
		player_ref = node
		player_ref.entered_game.emit(self)
	if node is MovingPlatforms:
		moving_platform_ref.append(node)
	if node is Trap:
		trap_ref.append(node)
	if node is Fan:
		fan_ref.append(node)


func _on_timeshift(timeshift_type : String, timescale : int) -> void:
	for n in moving_platform_ref :
		n.platform_timeshift.emit(timeshift_type, timescale)
	for n in trap_ref :
		n.trap_timeshift.emit(timeshift_type, timescale)
	for n in fan_ref :
		n.fan_timeshift.emit(timeshift_type, timescale)
