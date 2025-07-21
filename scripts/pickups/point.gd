extends Node2D

@onready var coin_sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

var sound:AudioStream = preload("uid://bl3fvseth7odf") #sfxultimate2017/Menu_008.ogg
func _ready() -> void:
	sprite.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && area_2d.monitoring == true:
		area_2d.monitoring = false
		self.visible = false
		AudioPlayer.play_FX(sound)
		
		await get_tree().create_timer(sound.get_length(), true, true, true).timeout
		self.queue_free()
