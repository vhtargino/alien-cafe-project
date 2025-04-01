extends CanvasLayer


func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%QuitGameButton.pressed.connect(on_quit_game_button_pressed)


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_game_button_pressed():
	get_tree().quit()
