extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene
@export_range(1, 3) var current_level: int

@onready var timer = $Timer

var arena_difficulty = 0


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	var next_time_intverval = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_intverval:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	if current_level == 1:
		GameEvents.stage_1_finished = true
	elif current_level == 2:
		GameEvents.stage_2_finished = true
	
	var end_screen_instance = end_screen_scene.instantiate()
	SoundUtils.play_music_player("victory_music")
	add_child(end_screen_instance)
