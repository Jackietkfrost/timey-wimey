extends LevelManager

@onready var scene_transition: ColorRect = $Scene_Transition/transition
@onready var trans_player: AnimationPlayer = $Scene_Transition/trans_player


func _ready() -> void:
	print("Ready Level One")
	scene_transition.get_parent().get_node("transition").color.a = 255
	trans_player.play("fade_out")
	await get_tree().create_timer(1).timeout
	print("Fade out done")

func _on_child_entered_game(node: Node) -> void:
	manage_Children(node)
	
