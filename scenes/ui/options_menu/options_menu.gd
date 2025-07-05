extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@export var controls_screen_scene: PackedScene

@onready var back_button: Button = %BackButton
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var language_v_box_container: VBoxContainer = %LanguageVBoxContainer
@onready var language_options: OptionButton = %LanguageOptions
@onready var controls_button: Button = %ControlsButton


func _ready():
	set_language_menu()
	
	for slider in get_tree().get_nodes_in_group("sliders"):
		slider.focus_entered.connect(on_focus_entered)
	
	back_button.pressed.connect(on_back_pressed)
	back_button.focus_entered.connect(on_focus_entered)
	
	controls_button.pressed.connect(on_controls_pressed)
	controls_button.focus_entered.connect(on_focus_entered)
	
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	music_slider.value_changed.connect(func(value): _set_bus_volume("Music", value))
	sfx_slider.value_changed.connect(func(value): _set_bus_volume("SFX", value))
	
	language_options.focus_entered.connect(on_focus_entered)
	language_options.pressed.connect(on_language_pressed)
	language_options.item_focused.connect(on_item_focused)
	language_options.item_selected.connect(on_item_selected)
	
	SoundUtils.enable_and_disable_focus_sound(music_slider)


func _set_bus_volume(bus_name: String, value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func set_language_menu():
	if not get_parent() is MainMenu:
		language_v_box_container.queue_free()
		return

	var language_map = {
		"Português": "pt_BR",
		"English": "en"
	}
	
	language_options.clear()
	for lang_name in language_map.keys():
		language_options.add_item(lang_name)

	var current_locale = TranslationServer.get_locale()

	var index_to_select = 0
	for i in language_map.size():
		var lang_name = language_options.get_item_text(i)
		if language_map[lang_name].begins_with(current_locale.substr(0, 2)):
			index_to_select = i
			break
	language_options.select(index_to_select)

	language_options.item_selected.connect(func(index):
		var selected_lang_name = language_options.get_item_text(index)
		var new_locale = language_map[selected_lang_name]
		
		if TranslationServer.get_locale() != new_locale:
			TranslationServer.set_locale(new_locale)
			#get_tree().reload_current_scene()
	)


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_language_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_item_focused(_index: int):
	SoundUtils.play_ui_sound("focus")


func on_item_selected(_index: int):
	SoundUtils.play_ui_sound("button_pressed")


func on_controls_pressed():
	SoundUtils.play_ui_sound("button_pressed")
	var controls_screen_instance = controls_screen_scene.instantiate()
	add_child(controls_screen_instance)
	controls_screen_instance.controls_back_pressed.connect(on_controls_screen_closed.bind(controls_screen_instance))


func on_controls_screen_closed(controls_screen_instance: Node):
	controls_screen_instance.queue_free()
	SoundUtils.enable_and_disable_focus_sound(music_slider)


func on_back_pressed():
	SoundUtils.play_ui_sound("button_pressed")
	back_pressed.emit()
