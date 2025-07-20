extends AudioStreamPlayer

const level_music = preload("uid://igvime6g0jrt")

func _play_music(music: AudioStream, volume: float = 0.0):
	if self.stream == music:
		print("passing")
		return
		
	self.stream = music
	print("new stream: " + str(self.stream))
	volume_db = volume
	self.play()
		
## Plays the game's level music
func play_music_level(vol = 0.0):
	_play_music(level_music, vol)

func play_FX(stream: AudioStream, volume: float = 0.0):
	var fx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
