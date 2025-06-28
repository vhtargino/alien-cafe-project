extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var velocity_component = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

@onready var normal_material : Material = animated_sprite_2d.material
@export var freeze_material: ShaderMaterial

@export var damage: int = 1

#var is_frozen: bool = false


func _ready():
	SoundUtils.play_music_player("boss_03_music")
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(on_died)
	hurtbox_component.hit.connect(on_hit)
	
	update_health_display()


func _process(_delta: float) -> void:
	#if is_frozen:
		#velocity = Vector2.ZERO
		#move_and_slide()
		#return
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	animated_sprite_2d.play("walk")
	
	var move_sign = sign(velocity.x)
	if velocity.x != 0:
		animated_sprite_2d.scale = Vector2(-move_sign, 1)


func update_health_display():
	health_bar.value = health_component.current_health


#func freeze():
	#is_frozen = true
	#animated_sprite_2d.stop()
	#animated_sprite_2d.material = freeze_material
#
#
#func unfreeze():
	#is_frozen = false
	#animated_sprite_2d.play("walk")
	#animated_sprite_2d.material = normal_material


func on_health_changed():
	update_health_display()


func on_hit():
	pass


func on_died():
	SoundUtils.play_boss_death_player()
