extends CanvasLayer

@onready var play_button = %PlayButton
@onready var store_button = %StoreButton
@onready var options_button = %OptionsButton
@onready var quit_game_button = %QuitGameButton

var options_scene = preload("res://scenes/ui/options_menu/options_menu.tscn")


func _ready():
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	play_button.pressed.connect(on_play_pressed)
	store_button.pressed.connect(on_store_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_game_button.pressed.connect(on_quit_game_button_pressed)
	
	if not MainMusicPlayer.playing:
		MainMusicPlayer.play()
	
	play_button.grab_focus()
	SoundUtils.enable_focus_sound()


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/level_select/level_select.tscn")


func on_store_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/store_menu/store_menu.tscn")


func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_game_button_pressed():
	get_tree().get_root().set_disable_input(true)
	
	if SoundUtils.ui_player.playing:
		await SoundUtils.ui_player.finished
	
	get_tree().quit()


func on_options_closed(options_instance: Node):
	SoundUtils.disable_focus_sound()
	options_instance.queue_free()
	play_button.grab_focus()
	SoundUtils.enable_focus_sound()
