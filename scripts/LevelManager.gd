class_name LevelManager extends Node2D


var player_ref : Node2D
var moving_platform_ref : Array[MovingPlatforms] = []
var trap_ref : Array[Trap] = []
var fan_ref : Array[Fan] = []
var enemies_ref: Array[Enemy_Base] = []

signal timeshift(timescale : float)

func _ready() -> void:
	
	AudioPlayer.play_music_level()

# TODO: Fix this to send all instead, and let on child_entered_tree handle this by checking if
# the child is directly a Node, or something like it. Maybe get them by grouping instead? 
func manage_Children(node: Node) -> void:
	if node.name == "Player":
		_on_child_entered_tree(node)
	if node.name == "enemies":
		for child in node.get_children():
			print("enemy " + str(child.name) + " adding!")
			if child.name == "flying enemies":
				for flyingChild in node.get_children():
					_on_child_entered_tree(flyingChild)
			_on_child_entered_tree(child)
	if node.name == "traps":
		for child in node.get_children():
			print("Trap " + str(child.name) + " adding!")
			_on_child_entered_tree(child)
	if node.name == "fans":
		for child in node.get_children():
			print("Fan " + str(child.name) + " adding!")
			_on_child_entered_tree(child)
	
	
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
