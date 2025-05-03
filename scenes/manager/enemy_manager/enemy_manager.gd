extends Node

const SPAWN_RADIUS = 330

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var cactus_enemy_scene: PackedScene
@export var spider_enemy_scene: PackedScene
@export var cyclops_enemy_scene: PackedScene
@export var crab_enemy_scene: PackedScene
@export var knight_enemy_scene: PackedScene
@export var rogue_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var boss_enemy_1: PackedScene

@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time

var enemy_table = WeightedTable.new()


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
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
	spawn_enemy(enemy_scene)


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.3 / 12) * arena_difficulty
	time_off = min(time_off, 0.85)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 12:
		enemy_table.add_item(wizard_enemy_scene, 20)
	elif arena_difficulty == 24:
		enemy_table.add_item(cactus_enemy_scene, 40)
	elif arena_difficulty == 36:
		enemy_table.remove_item(basic_enemy_scene)
		enemy_table.add_item(spider_enemy_scene, 80)
	elif arena_difficulty == 48:
		enemy_table.remove_item(wizard_enemy_scene)
		enemy_table.add_item(cyclops_enemy_scene, 160)
	elif arena_difficulty == 60:
		enemy_table.remove_item(cactus_enemy_scene)
		enemy_table.add_item(crab_enemy_scene, 320)
	elif arena_difficulty == 72:
		enemy_table.remove_item(spider_enemy_scene)
		enemy_table.add_item(knight_enemy_scene, 640)
	elif arena_difficulty == 84:
		enemy_table.remove_item(cyclops_enemy_scene)
		enemy_table.add_item(rogue_enemy_scene, 1280)
	elif arena_difficulty == 96:
		enemy_table.remove_item(crab_enemy_scene)
		enemy_table.add_item(ghost_enemy_scene, 2560)
	elif arena_difficulty == 108:
		spawn_enemy(boss_enemy_1)
