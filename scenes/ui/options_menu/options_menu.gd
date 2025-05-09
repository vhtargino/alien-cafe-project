extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@onready var back_button = %BackButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider


func _ready():
	for slider in get_tree().get_nodes_in_group("sliders"):
		slider.focus_entered.connect(on_focus_entered)
	
	back_button.pressed.connect(on_back_pressed)
	back_button.focus_entered.connect(on_focus_entered)
	
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	music_slider.value_changed.connect(func(value): _set_bus_volume("Music", value))
	sfx_slider.value_changed.connect(func(value): _set_bus_volume("SFX", value))
	
	SoundUtils.disable_focus_sound()
	music_slider.grab_focus()
	SoundUtils.enable_focus_sound()


func _set_bus_volume(bus_name: String, value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_back_pressed():
	SoundUtils.play_ui_sound("button_pressed")
	back_pressed.emit()
