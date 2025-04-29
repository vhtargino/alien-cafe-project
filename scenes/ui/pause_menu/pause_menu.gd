extends CanvasLayer

@export var options_menu_scene: PackedScene

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_to_menu_button: Button = %QuitToMenuButton

var is_closing = false


func _ready():
	get_tree().paused = true
	
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_to_menu_button.pressed.connect(on_quit_to_menu_pressed)
	
	SoundUtils.enable_music_filter()
	resume_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SoundUtils.disable_music_filter()
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	
	is_closing = true
	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	await SoundUtils.check_button_sound_playing(resume_button)
	SoundUtils.disable_music_filter()
	close()


func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_quit_to_menu_pressed():
	get_tree().get_root().set_disable_input(true)
	await SoundUtils.check_button_sound_playing(quit_to_menu_button)
	get_tree().get_root().set_disable_input(false)
	get_tree().paused = false
	SoundUtils.disable_music_filter()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func on_options_back_pressed(options_menu: Node):
	options_menu.queue_free()
	resume_button.grab_focus()
