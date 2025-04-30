extends CanvasLayer

@onready var level_1_button: SoundButton = %Level1Button
@onready var level_2_button: SoundButton = %Level2Button
@onready var level_3_button: SoundButton = %Level3Button
@onready var back_button: SoundButton = %BackButton


func _ready():
	level_1_button.pressed.connect(on_level_1_pressed)
	level_2_button.pressed.connect(on_level_2_pressed)
	level_3_button.pressed.connect(on_level_3_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	check_level_finished()
	
	level_1_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		#get_tree().get_root().set_disable_input(true)
		#await SoundUtils.check_button_sound_playing(back_button)
		#get_tree().get_root().set_disable_input(false)
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func check_level_finished():
	if GameEvents.level_1_finished == true:
		level_2_button.disabled = false
	elif GameEvents.level_2_finished == true:
		level_3_button.disabled = false


func on_level_1_pressed():
	get_tree().get_root().set_disable_input(true)
	await SoundUtils.check_button_sound_playing(level_1_button)
	get_tree().get_root().set_disable_input(false)
	MainMusicPlayer.stop()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_level_2_pressed():
	pass


func on_level_3_pressed():
	pass


func on_back_pressed():
	get_tree().get_root().set_disable_input(true)
	await SoundUtils.check_button_sound_playing(back_button)
	get_tree().get_root().set_disable_input(false)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
