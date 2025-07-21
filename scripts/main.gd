extends Node2D

var player_ref : Node2D
var moving_platform_ref : Array[MovingPlatforms] = []
var trap_ref : Array[Trap] = []
var fan_ref : Array[Fan] = []
var enemies_ref: Array[Enemy_Base] = []

signal timeshift(timescale : float)

func _ready() -> void:
	AudioPlayer.play_music_level()

func _on_child_entered_tree(node: Node) -> void:
	if node is Player:
		player_ref = node
		player_ref.entered_game.emit(self)
	if node is MovingPlatforms:
		moving_platform_ref.append(node)
	if node is Trap:
		trap_ref.append(node)
	if node is Fan:
		fan_ref.append(node)
	if node is Enemy_Base:
		enemies_ref.append(node)

func _on_timeshift(new_timescale : float) -> void:
	for n in moving_platform_ref :
		n.timeshift.emit(new_timescale)
	for n in trap_ref :
		n.timeshift.emit(new_timescale)
	for n in fan_ref :
		n.timeshift.emit(new_timescale)
	for n in enemies_ref: 
		n.timeshift.emit(new_timescale)
