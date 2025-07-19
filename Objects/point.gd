extends Node2D

@onready var coin_sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		coin_sound.autoplay = true
		coin_sound.playing = true
		self.visible = false
		await get_tree().create_timer(coin_sound.stream.get_length(), true, true, true).timeout
		self.queue_free()
