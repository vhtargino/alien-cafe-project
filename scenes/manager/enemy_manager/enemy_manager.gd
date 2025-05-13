extends Node

const SPAWN_RADIUS = 340

@export var alien_0001_scene: PackedScene
@export var alien_0002_scene: PackedScene
@export var alien_0003_scene: PackedScene
@export var alien_0004_scene: PackedScene
@export var alien_0005_scene: PackedScene
@export var alien_0006_scene: PackedScene
@export var alien_0007_scene: PackedScene
@export var alien_0008_scene: PackedScene
@export var alien_0009_scene: PackedScene
@export var boss_0001_scene: PackedScene

@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time

var enemy_table = WeightedTable.new()
var number_to_spawn: int = 1


func _ready():
	enemy_table.add_item(alien_0001_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func spawn_enemy(enemy_scene: PackedScene):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position


func on_timer_timeout():
	timer.start()
	var enemy_scene = enemy_table.pick_item()
	for i in number_to_spawn:
		spawn_enemy(enemy_scene)


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.3 / 12) * arena_difficulty
	time_off = min(time_off, 0.85)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 12:
		enemy_table.add_item(alien_0002_scene, 20)
	elif arena_difficulty == 24:
		enemy_table.add_item(alien_0003_scene, 40)
	elif arena_difficulty == 36:
		enemy_table.remove_item(alien_0001_scene)
		enemy_table.add_item(alien_0004_scene, 80)
	elif arena_difficulty == 48:
		enemy_table.remove_item(alien_0002_scene)
		enemy_table.add_item(alien_0005_scene, 160)
	elif arena_difficulty == 60:
		enemy_table.remove_item(alien_0003_scene)
		enemy_table.add_item(alien_0006_scene, 320)
		number_to_spawn += 1
	elif arena_difficulty == 72:
		enemy_table.remove_item(alien_0004_scene)
		enemy_table.add_item(alien_0007_scene, 640)
	elif arena_difficulty == 84:
		enemy_table.remove_item(alien_0005_scene)
		enemy_table.add_item(alien_0008_scene, 1280)
	elif arena_difficulty == 96:
		enemy_table.remove_item(alien_0006_scene)
		enemy_table.add_item(alien_0009_scene, 2560)
	elif arena_difficulty == 108:
		spawn_enemy(boss_0001_scene)
	
	#if (arena_difficulty % 60) == 0:
		#number_to_spawn += 1
