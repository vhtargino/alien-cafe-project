extends Node

const FOCUS = preload("res://assets/audio/menu-button-focus.ogg")
const BUTTON_PRESSED = preload("res://assets/audio/beep-confirm.ogg")
const DENIED = preload("res://assets/audio/wrong.mp3")

const PLAYER_DAMAGE = preload("res://assets/audio/player_hit.ogg")
const HEALING = preload("res://assets/audio/health_up.ogg")

const PORTAFILTER_SOUND = preload("res://assets/audio/sword_sound.ogg")
const TURKISH_SOUND = preload("res://assets/audio/spinning_woosh.ogg")

const DOUBLE_SHOT_SOUND = preload("res://assets/audio/knife-sound.mp3")
const ICED_COFFEE_SOUND = preload("res://assets/audio/wind.ogg")
const TURBO_EXPRESSO = preload("res://assets/audio/high-speed.mp3")

@onready var ui_player: AudioStreamPlayer = $UiPlayer
@onready var player_player: AudioStreamPlayer = $PlayerPlayer
@onready var weapons_player: AudioStreamPlayer = $WeaponsPlayer
@onready var enemy_player: AudioStreamPlayer = $EnemyPlayer
@onready var booster_sounds_player: AudioStreamPlayer = $BoosterSoundsPlayer
@onready var experience_collect_player: AudioStreamPlayer = $ExperienceCollectPlayer
@onready var health_collect_player: AudioStreamPlayer = $HealthCollectPlayer

var boosters_polyphonic_playback: AudioStreamPlaybackPolyphonic
var weapons_polyphonic_playback: AudioStreamPlaybackPolyphonic

var allow_focus_sound: bool = false


func _ready():
	booster_sounds_player.play()
	boosters_polyphonic_playback = booster_sounds_player.get_stream_playback()


func enable_focus_sound():
	allow_focus_sound = true


func disable_focus_sound():
	allow_focus_sound = false


func play_ui_sound(sound_name: String):
	if sound_name == "focus" and not allow_focus_sound:
		return
	
	match sound_name:
		"focus": ui_player.stream = FOCUS
		"button_pressed": ui_player.stream = BUTTON_PRESSED
		"denied": ui_player.stream = DENIED
	ui_player.play()


func play_player_sound(sound_name: String):
	match sound_name:
		"damage": 
			player_player.stream = PLAYER_DAMAGE
	player_player.play()


func play_weapons_sound(sound_name: String):
	match sound_name:
		"portafilter": boosters_polyphonic_playback.play_stream(PORTAFILTER_SOUND)
		"turkish": boosters_polyphonic_playback.play_stream(TURKISH_SOUND)


func play_enemy_sound():
	enemy_player.play()


func play_booster_sound(sound_name: String):
	match sound_name:
		"double_shot": boosters_polyphonic_playback.play_stream(DOUBLE_SHOT_SOUND)
		"waker": boosters_polyphonic_playback.play_stream(HEALING)
		"iced_coffee": boosters_polyphonic_playback.play_stream(ICED_COFFEE_SOUND)
		"turbo_expresso": boosters_polyphonic_playback.play_stream(TURBO_EXPRESSO)


func play_experience_sound():
	experience_collect_player.play()


func play_health_sound():
	health_collect_player.play()


func enable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)
	AudioServer.set_bus_effect_enabled(bus_index, 1, true)


func disable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
	AudioServer.set_bus_effect_enabled(bus_index, 1, false)
