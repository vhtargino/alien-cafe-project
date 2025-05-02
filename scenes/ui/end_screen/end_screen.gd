extends CanvasLayer

@onready var restart_button: Button = %RestartButton
@onready var quit_to_menu_button: Button = %QuitToMenuButton


func _ready():
	get_tree().paused = true
	
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_to_menu_button.pressed.connect(on_quit_to_menu_button_pressed)
	
	SoundUtils.disable_focus_sound()
	restart_button.grab_focus()
	SoundUtils.enable_focus_sound()


func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func on_quit_to_menu_button_pressed():
	get_tree().paused = false
	SoundUtils.disable_focus_sound()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
