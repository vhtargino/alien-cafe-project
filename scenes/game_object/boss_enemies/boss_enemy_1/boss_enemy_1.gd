extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var velocity_component = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

@onready var normal_material : Material = sprite.material

@export var damage: int = 1
@export var freeze_material: ShaderMaterial

var is_frozen: bool = false


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(_delta: float) -> void:
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if velocity.x != 0:
		visuals.scale = Vector2(-move_sign, 1)


func freeze():
	is_frozen = true
	sprite.material = freeze_material


func unfreeze():
	is_frozen = false
	sprite.material = normal_material


func on_hit():
	$EnemyHitRandomStreamPlayerComponent.play_random()
