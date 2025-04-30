extends Node

@onready var selected_audio_player: AudioStreamPlayer = $SelectedAudioPlayer


func check_button_sound_playing(button):
	if button.random_stream_player_component.playing:
		await button.random_stream_player_component.finished


func check_player_sound_playing(player: AudioStreamPlayer):
	if player.playing:
		await player.finished


func enable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)
	AudioServer.set_bus_effect_enabled(bus_index, 1, true)


func disable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
	AudioServer.set_bus_effect_enabled(bus_index, 1, false)
