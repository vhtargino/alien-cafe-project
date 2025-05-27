extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var velocity_component = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent

@onready var normal_material : Material = animated_sprite_2d.material
@export var freeze_material: ShaderMaterial

@export var damage: int = 1

var is_frozen: bool = false
var is_despawning: bool = false


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(_delta: float) -> void:
	if is_frozen or is_despawning:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	animated_sprite_2d.play("walk")
	
	var move_sign = sign(velocity.x)
	if velocity.x != 0:
		animated_sprite_2d.scale = Vector2(-move_sign, 1)


func freeze():
	is_frozen = true
	animated_sprite_2d.stop()
	animated_sprite_2d.material = freeze_material


func unfreeze():
	is_frozen = false
	animated_sprite_2d.play("walk")
	animated_sprite_2d.material = normal_material


func despawn():
	is_despawning = true
	
	hurtbox_component.queue_free()
	animated_sprite_2d.material = normal_material
	
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "global_position", (global_position + (Vector2.UP * 150)), 0.8)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_IN)
	
	animated_sprite_2d.play("despawn")
	await animated_sprite_2d.animation_finished
	queue_free()


func on_hit():
	pass


func on_died():
	pass
