extends Node2D
class_name ForceFieldAbility

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.scale = Vector2(1.0, 1.0)
	hitbox_component.get_child(0).shape.radius = 25.0
