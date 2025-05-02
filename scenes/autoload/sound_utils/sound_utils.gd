extends Node

const FOCUS = preload("res://assets/audio/menu-button-focus.ogg")
const BUTTON_PRESSED = preload("res://assets/audio/beep-confirm.ogg")

@onready var ui_player: AudioStreamPlayer = $UiPlayer

var allow_focus_sound: bool = false


func play_ui_sound(name: String):
	if name == "focus" and not allow_focus_sound:
		return
	
	match name:
		"button_pressed": ui_player.stream = BUTTON_PRESSED
		"focus": ui_player.stream = FOCUS
	if not ui_player.playing:
		ui_player.play()


func enable_focus_sound():
	allow_focus_sound = true


func disable_focus_sound():
	allow_focus_sound = false


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
