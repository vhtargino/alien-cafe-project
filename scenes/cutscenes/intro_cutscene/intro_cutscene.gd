extends Node2D

@export var main_menu_scene: PackedScene
@onready var label: Label = $PanelContainer/MarginContainer/Label

var texto_1: String = tr("INTRO_LINE_1")


func _ready() -> void:
	SoundUtils.play_music_player("intro_cutscene")
	label.text = texto_1


func change_text(text: String):
	label.text = text


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		stop_text_sound()
		go_to_main_menu()


func go_to_main_menu():
	get_tree().change_scene_to_packed(main_menu_scene)


func play_text_sound():
	SoundUtils.play_text_sound()


func stop_text_sound():
	SoundUtils.stop_text_sound()
