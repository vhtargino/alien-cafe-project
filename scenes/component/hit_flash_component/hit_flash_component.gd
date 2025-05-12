extends Node

@export var health_component: Node
@export var sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready():
	health_component.health_changed.connect(on_health_changed)
	check_sprite()


func on_health_changed():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	var target = sprite if sprite != null else animated_sprite
	create_hit_flash_tween(target)


func check_sprite():
	if sprite != null:
		sprite.material = hit_flash_material
	
	if animated_sprite != null:
		animated_sprite.material = hit_flash_material


func create_hit_flash_tween(target: CanvasItem):
	(target.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(target.material, "shader_parameter/lerp_percent", 0.0, .25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
