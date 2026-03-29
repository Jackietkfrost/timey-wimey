extends AudioStreamPlayer


@export var music_playlist:AudioStreamPlaylist 

var current_index = 0

## Plays the playlist of audio
func _play_music(music: AudioStreamPlaylist, volume: float = 0.0):
	if self.stream == music:
		return

	self.stream = music
	volume_db = volume
	self.play()

## Plays the game's level music
func play_music_level(vol:float = 0.0):
	self.bus = "Music"
	_play_music(music_playlist, vol)

func play_FX(audioStream: AudioStream, volume: float = 0.0):
	var fx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	fx_player.stream = audioStream
	fx_player.volume_db = volume
	fx_player.bus = "SFX"
	add_child(fx_player)
	fx_player.play()

	await fx_player.finished
	fx_player.queue_free()
	
func play_next_song():
	if music_playlist.size() == 0: return
	#stream = playlist[current_index]
	play()
	current_index = (current_index + 1) % music_playlist.size()

# Call this to change the playlist entirely
func change_playlist(new_list):
	music_playlist = new_list
	current_index = 0
	play_next_song()

func change_and_play(new_stream):
	stream = new_stream
	play()
	# Fade in new
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0, 1.0)
