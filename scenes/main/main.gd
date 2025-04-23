extends Node2D

@export var end_screen_scene: PackedScene
@export var pause_menu_scene: PackedScene


func _ready():
	%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


func create_camera():
	var camera = Camera2D.new()
	camera.position = %Player.global_position
	camera.make_current()
	add_child(camera)


func on_player_died():
	#create_camera()
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
