extends Node2D

var player_ref : Node2D
var moving_platform_ref : Node2D

signal timeshift(timeshift_type : String)

func _ready() -> void:
	AudioPlayer.play_music_level()

func _on_child_entered_tree(node: Node) -> void:
	print("Child entered: " + str(node.name))
	if node is Player:
		player_ref = node
		player_ref.entered_game.emit(self)
	if node is MovingPlatforms:
		moving_platform_ref = node

func _on_timeshift(timeshift_type : String ) -> void:
	match timeshift_type :
		"Rewind" :
			moving_platform_ref.platform_timeshift.emit("Rewind", 3.0, -1)
		"Pause" :
			moving_platform_ref.platform_timeshift.emit("Pause", 3.0, 0)
