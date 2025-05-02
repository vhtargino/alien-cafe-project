extends CanvasLayer

@export var options_menu_scene: PackedScene

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_to_menu_button: Button = %QuitToMenuButton

var is_closing = false


func _ready():
	get_tree().paused = true
	
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_to_menu_button.pressed.connect(on_quit_to_menu_pressed)
	
	SoundUtils.enable_music_filter()
	SoundUtils.disable_focus_sound()
	resume_button.grab_focus()
	SoundUtils.enable_focus_sound()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SoundUtils.disable_music_filter()
		close()
		get_tree().root.set_input_as_handled()


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func close():
	if is_closing:
		return
	
	is_closing = true
	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	SoundUtils.disable_music_filter()
	close()


func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_quit_to_menu_pressed():
	get_tree().paused = false
	SoundUtils.disable_music_filter()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func on_options_back_pressed(options_menu: Node):
	SoundUtils.disable_focus_sound()
	options_menu.queue_free()
	resume_button.grab_focus()
	SoundUtils.enable_focus_sound()
	
