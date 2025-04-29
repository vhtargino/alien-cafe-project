extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@onready var back_button = %BackButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var can_play_focus_sound = false


func _ready():
	back_button.pressed.connect(on_back_pressed)
	%MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	%SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	%MusicSlider.value_changed.connect(func(value): _set_bus_volume("Music", value))
	%SFXSlider.value_changed.connect(func(value): _set_bus_volume("SFX", value))
	
	%MusicSlider.focus_entered.connect(on_music_slider_focus_entered)
	%SFXSlider.focus_entered.connect(on_sfx_slider_focus_entered)
	
	await get_tree().process_frame
	%MusicSlider.grab_focus()
	can_play_focus_sound = true


func _set_bus_volume(bus_name: String, value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func on_music_slider_focus_entered():
	if can_play_focus_sound:
		audio_stream_player.play()


func on_sfx_slider_focus_entered():
	audio_stream_player.play()


func on_back_pressed():
	get_tree().get_root().set_disable_input(true)
	await SoundUtils.check_button_sound_playing(back_button)
	get_tree().get_root().set_disable_input(false)
	back_pressed.emit()
