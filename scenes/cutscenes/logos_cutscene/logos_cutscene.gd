extends Node2D

@export var intro_cutscene_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("default")
	
	await animation_player.animation_finished
	go_to_intro()


func go_to_intro():
	get_tree().change_scene_to_packed(intro_cutscene_scene)
