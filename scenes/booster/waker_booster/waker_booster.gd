extends Node

@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_2"):
		activate_waker_booster()


func activate_waker_booster():
	if effect_active:
		return
	
	if BoosterEvents.waker <= 0:
		return
	
	sprite.visible = true
	effect_active = true
	BoosterEvents.waker -= 1
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	sprite.global_position = player.global_position
	sprite.play("healing")
	
	BoosterEvents.emit_waker_booster_applied()
	timer.start()
	
	await sprite.animation_finished
	sprite.visible = false


func on_timer_timeout():
	effect_active = false
