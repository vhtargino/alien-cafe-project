extends Button
class_name SoundButton

@onready var random_stream_player_component: AudioStreamPlayer = $RandomStreamPlayerComponent
@onready var focused_player_component: AudioStreamPlayer = $FocusedPlayerComponent

var can_play_focus_sound = false


func _ready():
	focus_entered.connect(on_focus)
	pressed.connect(on_pressed)
	
	await get_tree().process_frame
	can_play_focus_sound = true


func on_focus():
	if can_play_focus_sound:
		focused_player_component.play_random()


func on_pressed():
	random_stream_player_component.play_random()
