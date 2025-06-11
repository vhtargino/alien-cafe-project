extends Node2D

@export var end_screen_scene: PackedScene
@export var pause_menu_scene: PackedScene


func _ready():
	SoundUtils.play_music_player("stage_1")
	%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


func create_camera():
	var camera = Camera2D.new()
	add_child(camera)


func on_player_died():
	create_camera()
	SoundUtils.stop_players()
	var end_screen_instance = end_screen_scene.instantiate()
	SoundUtils.play_music_player("game_over_music")
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
