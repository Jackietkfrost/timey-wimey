extends LevelManager

@onready var scene_transition: ColorRect = $Player/Scene_Transition/transition
@onready var trans_player: AnimationPlayer = $Player/Scene_Transition/trans_player

func _ready() -> void:
	scene_transition.color.a = 255
	scene_transition.visible = true
	trans_player.play("fade_out")
	await get_tree().create_timer(1).timeout

func _on_child_entered_game(node: Node) -> void:
	manage_Children(node)
	
