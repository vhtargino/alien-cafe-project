extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)
	color_rect.visible = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_2"):
		activate_waker_booster()


func activate_waker_booster():
	if effect_active:
		return
	
	if BoosterEvents.waker <= 0:
		return
	
	SoundUtils.play_waker_sound()
	effect_active = true
	BoosterEvents.waker -= 1
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	animation_player.play("green_screen_flash")
	player.play_healing_animation()
	
	BoosterEvents.emit_waker_booster_applied()
	timer.start()


func on_timer_timeout():
	effect_active = false
	BoosterEvents.emit_waker_booster_ended()
