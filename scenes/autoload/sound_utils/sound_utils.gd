extends Node

const FOCUS = preload("res://assets/audio/menu-button-focus.ogg")
const BUTTON_PRESSED = preload("res://assets/audio/beep-confirm.ogg")

const DOUBLE_SHOT_SOUND = preload("res://assets/audio/knife-sound.mp3")
const ICED_COFFEE_SOUND = preload("res://assets/audio/wind.ogg")
const TURBO_EXPRESSO = preload("res://assets/audio/high-speed.mp3")

@onready var ui_player: AudioStreamPlayer = $UiPlayer
@onready var booster_sounds_player: AudioStreamPlayer = $BoosterSoundsPlayer
var booster_polyphonic_playback: AudioStreamPlaybackPolyphonic

var allow_focus_sound: bool = false


func _ready():
	booster_sounds_player.play()
	booster_polyphonic_playback = booster_sounds_player.get_stream_playback()


func play_ui_sound(sound_name: String):
	if sound_name == "focus" and not allow_focus_sound:
		return
	
	match sound_name:
		"focus": ui_player.stream = FOCUS
		"button_pressed": ui_player.stream = BUTTON_PRESSED
	ui_player.play()


func play_booster_sound(sound_name: String):
	match sound_name:
		"double_shot": booster_polyphonic_playback.play_stream(DOUBLE_SHOT_SOUND)
		"iced_coffee": booster_polyphonic_playback.play_stream(ICED_COFFEE_SOUND)
		"turbo_expresso": booster_polyphonic_playback.play_stream(TURBO_EXPRESSO)


func enable_focus_sound():
	allow_focus_sound = true


func disable_focus_sound():
	allow_focus_sound = false


func enable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)
	AudioServer.set_bus_effect_enabled(bus_index, 1, true)


func disable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
	AudioServer.set_bus_effect_enabled(bus_index, 1, false)
