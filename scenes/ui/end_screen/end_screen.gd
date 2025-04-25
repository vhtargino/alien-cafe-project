extends CanvasLayer

@onready var restart_button: Button = %RestartButton
@onready var quit_to_menu_button: Button = %QuitToMenuButton


func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_to_menu_button.pressed.connect(on_quit_to_menu_button_pressed)
	
	restart_button.grab_focus()


func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"


func on_restart_button_pressed():
	await SoundUtils.check_sound_playing(quit_to_menu_button)
	
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().reload_current_scene()


func on_quit_to_menu_button_pressed():
	await SoundUtils.check_sound_playing(quit_to_menu_button)
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
