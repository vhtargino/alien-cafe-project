extends Node

const MAIN_MENU_MUSIC = preload("res://assets/music/the-stakeout-anasta-music-288249.ogg")
const STAGE_1_MUSIC = preload("res://assets/music/synthwave-music-for-creating-a-captivating-background-ambiance-311391.ogg")
const STAGE_2_MUSIC = preload("res://assets/music/stage-2-music-chill-synthwave-background-music-for-youtube-shorts-and-videos-345551.mp3")
const BOSS_MUSIC = preload("res://assets/music/dark-synthwave-obilivion-echo-251687.ogg")
const VICTORY_MUSIC = preload("res://assets/music/neon-mirage-background-synthwave-music-for-video-vlog-24-second-340201.ogg")
const GAME_OVER_MUSIC = preload("res://assets/music/sad-documentary-sorrowful-music-342263.ogg")

const FOCUS = preload("res://assets/audio/menu-button-focus.ogg")
const BUTTON_PRESSED = preload("res://assets/audio/beep-confirm.ogg")
const DENIED = preload("res://assets/audio/wrong.mp3")

const PLAYER_DAMAGE = preload("res://assets/audio/player_hit.ogg")
const HEALING = preload("res://assets/audio/health_up.ogg")

@export var frying_pan_array: Array[AudioStream]
@export var espresso_crossbow_array: Array[AudioStream]

@export var experience_pod_array: Array[AudioStream]

@export var enemy_hit_array: Array[AudioStream]

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ui_player: AudioStreamPlayer = $UiPlayer

@onready var player_player: AudioStreamPlayer = $PlayerPlayer

@onready var sword_player: AudioStreamPlayer = $SwordPlayer
@onready var axe_player: AudioStreamPlayer = $AxePlayer
@onready var spear_player: AudioStreamPlayer = $SpearPlayer
@onready var anvil_player: AudioStreamPlayer = $AnvilPlayer

@onready var enemy_player: AudioStreamPlayer = $EnemyPlayer

@onready var double_shot_player: AudioStreamPlayer = $DoubleShotPlayer
@onready var waker_player: AudioStreamPlayer = $WakerPlayer
@onready var iced_coffee_player: AudioStreamPlayer = $IcedCoffeePlayer
@onready var turbo_expresso_player: AudioStreamPlayer = $TurboExpressoPlayer

@onready var level_up_player: AudioStreamPlayer = $LevelUpPlayer
@onready var experience_collect_player: AudioStreamPlayer = $ExperienceCollectPlayer
@onready var health_collect_player: AudioStreamPlayer = $HealthCollectPlayer

@onready var boss_death_player: AudioStreamPlayer = $BossDeathPlayer

var allow_focus_sound: bool = false


# Music
func play_music_player(sound_name: String):
	match sound_name:
		"main_menu": music_player.stream = MAIN_MENU_MUSIC
		"stage_1": music_player.stream = STAGE_1_MUSIC
		"stage_2": music_player.stream = STAGE_2_MUSIC
		"boss_music": music_player.stream = BOSS_MUSIC
		"victory_music": music_player.stream = VICTORY_MUSIC
		"game_over_music": music_player.stream = GAME_OVER_MUSIC
	music_player.play()


# UI
func play_ui_sound(sound_name: String):
	if sound_name == "focus" and not allow_focus_sound:
		return
	
	match sound_name:
		"focus": ui_player.stream = FOCUS
		"button_pressed": ui_player.stream = BUTTON_PRESSED
		"denied": ui_player.stream = DENIED
	ui_player.play()


# Player
func play_player_sound(sound_name: String):
	match sound_name:
		"damage": 
			player_player.stream = PLAYER_DAMAGE
	player_player.play()


# Weapons
func play_sword_sound():
	sword_player.stream = frying_pan_array.pick_random()
	sword_player.play()


func play_axe_sound():
	axe_player.play()


func play_spear_sound():
	spear_player.stream = espresso_crossbow_array.pick_random()
	spear_player.play()


func play_anvil_sound():
	anvil_player.play()


# Enemies
func play_enemy_sound():
	enemy_player.stop()
	enemy_player.stream = enemy_hit_array.pick_random()
	enemy_player.play()


func play_boss_death_player():
	boss_death_player.play()


# Boosters
func play_double_shot_sound():
	double_shot_player.play()


func play_waker_sound():
	waker_player.play()


func play_iced_coffee_sound():
	iced_coffee_player.play()


func play_turbo_expresso_sound():
	turbo_expresso_player.play()


# Level up
func play_level_up_player():
	level_up_player.play()


# Item collect
func play_experience_sound():
	experience_collect_player.stream = experience_pod_array.pick_random()
	experience_collect_player.play()


func play_health_sound():
	health_collect_player.play()


# Utilitarians
func enable_focus_sound():
	allow_focus_sound = true


func disable_focus_sound():
	allow_focus_sound = false


func enable_and_disable_focus_sound(node: Control):
	if not node.focus_mode != Control.FOCUS_NONE:
		return
	disable_focus_sound()
	node.grab_focus()
	enable_focus_sound()


func stop_players():
	for audio_player: AudioStreamPlayer in get_tree().get_nodes_in_group("sound_players"):
		if audio_player.playing:
			audio_player.stop()


func enable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, true)
	AudioServer.set_bus_effect_enabled(bus_index, 1, true)


func disable_music_filter():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)
	AudioServer.set_bus_effect_enabled(bus_index, 1, false)
