extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent
#@onready var sprite: Sprite2D = $Sprite2D

var base_rotation

var tween_to: float
var tween_duration: float


func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var spawn_position = get_player_position()
	
	var tween = create_tween()
	tween.tween_method(tween_method.bind(spawn_position), 0.0, tween_to, tween_duration)
	tween.tween_callback(queue_free)


func tween_method(rotations: float, spawn_position):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	#var player = get_tree().get_first_node_in_group("player") as Node2D
	#if player == null:
		#return
	
	#global_position = player.global_position + (current_direction * current_radius)
	global_position = spawn_position + (current_direction * current_radius)


func get_player_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var player_position = player.global_position
	
	return player_position
