extends CanvasLayer

@onready var level_1_button: Button = %Level1Button
@onready var level_2_button: Button = %Level2Button
@onready var level_3_button: Button = %Level3Button
@onready var back_button: Button = %BackButton


func _ready():
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	level_1_button.pressed.connect(on_level_1_pressed)
	level_2_button.pressed.connect(on_level_2_pressed)
	level_3_button.pressed.connect(on_level_3_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	check_level_finished()
	
	SoundUtils.disable_focus_sound()
	level_1_button.grab_focus()
	SoundUtils.enable_focus_sound()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func check_level_finished():
	if GameEvents.level_1_finished == true:
		level_2_button.disabled = false
	elif GameEvents.level_2_finished == true:
		level_3_button.disabled = false


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_level_1_pressed():
	MainMusicPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_level_2_pressed():
	pass


func on_level_3_pressed():
	pass


func on_back_pressed():
	SoundUtils.disable_focus_sound()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
