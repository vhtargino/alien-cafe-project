extends Node2D

@export var main_menu_scene: PackedScene
@onready var label: Label = $PanelContainer/MarginContainer/Label

var texto_1: String = tr("INTRO_LINE_1")


func _ready() -> void:
	label.text = texto_1


func change_text(text: String):
	label.text = text


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		go_to_main_menu()


func go_to_main_menu():
	get_tree().change_scene_to_packed(main_menu_scene)
