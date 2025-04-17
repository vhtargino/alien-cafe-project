extends CanvasLayer

signal back_pressed

@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_pressed)
	%MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	%SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	%MusicSlider.value_changed.connect(func(value): _set_bus_volume("Music", value))
	%SFXSlider.value_changed.connect(func(value): _set_bus_volume("SFX", value))


func _set_bus_volume(bus_name: String, value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func on_back_pressed():
	back_pressed.emit()
