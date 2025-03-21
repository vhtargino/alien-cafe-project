extends Node

@export_range(0, 1) var drop_percent: float = .75
@export var health_component: Node
@export var experience_vial_scene: PackedScene
@export var experience_amount: float = 1


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return
	
	if experience_vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var experience_vial_instance = experience_vial_scene.instantiate() as Node2D
	experience_vial_instance.experience_amount = experience_amount
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(experience_vial_instance)
	experience_vial_instance.global_position = spawn_position
