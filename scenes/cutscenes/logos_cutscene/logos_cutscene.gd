extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("default")
	
	await animation_player.animation_finished
	change_to_menu()


func change_to_menu():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
