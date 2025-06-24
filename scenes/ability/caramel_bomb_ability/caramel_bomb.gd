extends Node2D

const CARAMEL_SPLASH_A = preload("res://assets/weapons/caramel_splash_a.png")

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D

var alpha_modulation: float = 1


func _ready() -> void:
	collision_shape_2d.disabled = true
	timer.timeout.connect(on_timer_timeout)


func change_sprite():
	sprite_2d.texture = CARAMEL_SPLASH_A
	collision_shape_2d.disabled = false
	sprite_2d.z_index = 0
	timer.start()
	modulate_alpha()


func modulate_alpha():
	for i in 4:
		sprite_2d.modulate = Color(1, 1, 1, alpha_modulation)
		await get_tree().create_timer(1).timeout
		alpha_modulation -= .25


func on_timer_timeout():
	queue_free()
