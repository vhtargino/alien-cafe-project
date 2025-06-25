extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: Node
@export var floating_text_scene: PackedScene

var player: Node2D


func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if other_area == null:
		return
	
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	var critical_multiplier: float = player.apply_critical_multiplier()
	var is_critical: bool = true if critical_multiplier > 1 else false
	var final_damage: float = hitbox_component.damage * critical_multiplier
	
	health_component.damage(final_damage)
	
	var text_color: Color = Color(1, 1, 0, 1) if is_critical else Color(1, 1, 1, 1)
	var floating_text_instance = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text_instance)
	
	floating_text_instance.global_position = global_position + (Vector2.UP * 8)
	floating_text_instance.start(str(int(final_damage * 10)), .2, text_color)
	
	SoundUtils.play_enemy_sound()
	#hit.emit()
