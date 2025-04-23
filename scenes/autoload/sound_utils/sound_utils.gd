extends Node


func check_sound_playing(button):
	if button.random_stream_player_component.playing:
		await button.random_stream_player_component.finished
