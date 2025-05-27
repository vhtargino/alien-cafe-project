extends Node

@export_range(0, 1) var drop_percent: float = .05
@export var health_component: Node
@export var health_vial_scene: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return
	
	if health_vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position + Vector2(randf_range(-12, 12), randf_range(-12, 12))
	var health_vial_instance = health_vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(health_vial_instance)
	health_vial_instance.global_position = spawn_position
