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
var enemy_count: int = 0


func _ready():
	enemy_table.add_item(alien_0001_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	GameEvents.enemy_died.connect(on_enemy_died)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 32:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 25
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		# Para visualizar linhas em modo debug:
		#if get_tree().debug_collisions_hint:
			#var debug_line = Line2D.new()
			#debug_line.z_index = 99 # Draw on top of everything
			#debug_line.width = 1
			#debug_line.add_point(query_parameters.from, 0)
			#debug_line.add_point(query_parameters.to, 1)
			#add_child(debug_line)
			#if !result.is_empty():
				#debug_line.set_point_position(1, result.get("position"))
				#debug_line.default_color = Color.RED
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(11.25))
		
	return spawn_position


func spawn_enemy(enemy_scene: PackedScene, is_boss: bool = false):
	if enemy_count >= 500 and not is_boss:
		return
	
	var spawn_position = get_spawn_position()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	var enemy = enemy_scene.instantiate() as Node2D
	
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position
	
	if not is_boss:
		enemy_count += 1


func despawn_enemy(enemy_scene: PackedScene):
	var enemy_scene_path = enemy_scene.resource_path
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.scene_file_path == enemy_scene_path:
			enemy.despawn()
			enemy_count -= 1


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
		despawn_enemy(alien_0001_scene)
		enemy_table.add_item(alien_0004_scene, 80)
	elif arena_difficulty == 48:
		enemy_table.remove_item(alien_0002_scene)
		despawn_enemy(alien_0002_scene)
		enemy_table.add_item(alien_0005_scene, 160)
	elif arena_difficulty == 60:
		enemy_table.remove_item(alien_0003_scene)
		despawn_enemy(alien_0003_scene)
		enemy_table.add_item(alien_0006_scene, 320)
		number_to_spawn += 1
	elif arena_difficulty == 72:
		enemy_table.remove_item(alien_0004_scene)
		despawn_enemy(alien_0004_scene)
		enemy_table.add_item(alien_0007_scene, 640)
	elif arena_difficulty == 84:
		enemy_table.remove_item(alien_0005_scene)
		despawn_enemy(alien_0005_scene)
		enemy_table.add_item(alien_0008_scene, 1280)
	elif arena_difficulty == 96:
		enemy_table.remove_item(alien_0006_scene)
		despawn_enemy(alien_0006_scene)
		enemy_table.add_item(alien_0009_scene, 2560)
	elif arena_difficulty == 108:
		SoundUtils.play_music_player("boss_music")
		spawn_enemy(boss_0001_scene, true)
	
	#if (arena_difficulty % 60) == 0:
		#number_to_spawn += 1


func on_enemy_died():
	enemy_count -= 1
