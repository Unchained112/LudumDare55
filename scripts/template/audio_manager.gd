extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer

func play_button_sound():
	sound_player.play()

func play_music_sound():
	music_player.play()
