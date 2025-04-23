extends CanvasLayer

@onready var play_button = %PlayButton
@onready var options_button = %OptionsButton
@onready var quit_game_button = %QuitGameButton

var options_scene = preload("res://scenes/ui/options_menu/options_menu.tscn")


func _ready():
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_game_button.pressed.connect(on_quit_game_button_pressed)
	
	play_button.grab_focus()


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_game_button_pressed():
	await SoundUtils.check_sound_playing(quit_game_button)
	
	get_tree().quit()


func on_options_closed(options_instance: Node):	
	options_instance.queue_free()
	play_button.grab_focus()
