extends Node

signal level_up_above_max()

@export var floating_text_scene: PackedScene

var damage: float = 1
var attack_rate: float = 1
var attack_range: float = 1

var move_speed: float = 1
var armor: float = 1
var max_health: float = 1
var health_regen: float = 1
var magnet: float = 1

var attributes: Array[String] = ["damage", "attack rate", "attack range", "move speed", "armor", "max health", "health regen", "magnet"]
var random_attribute: String


func increase_random_attribute():
	random_attribute = attributes.pick_random()
	match(random_attribute):
		"damage": damage += .05
		"attack rate": attack_rate -= .05
		"attack range": attack_range += .05
		"move speed": move_speed += .05
		"armor": armor += .05
		"max health": max_health += .05
		"health regen": health_regen += .05
		"magnet": magnet += .05
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
	
	var floating_text_instance = floating_text_scene.instantiate() as Node2D
	floating_text_instance.global_position = player.global_position + (Vector2.UP * 8)
	foreground_layer.add_child(floating_text_instance)
	floating_text_instance.start(random_attribute + " + 5%", .6, Color(0, 223, 0), 20)


func reset_attributes():
	damage = 1
	attack_rate = 1
	attack_range = 1
	move_speed = 1
	armor = 1
	max_health = 1
	health_regen = 1
	magnet = 1


func emit_level_up_above_max():
	level_up_above_max.emit()
