extends Node

@onready var timer: Timer = $Timer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_4"):
		activate_turbo_expresso_booster()


func activate_turbo_expresso_booster():
	if effect_active:
		return
	
	if BoosterEvents.turbo_expresso <= 0:
		return
	
	color_rect.visible = true
	SoundUtils.play_booster_sound("turbo_expresso")
	
	effect_active = true
	BoosterEvents.turbo_expresso -= 1
	
	BoosterEvents.emit_turbo_expresso_booster_applied()
	timer.start()


func on_timer_timeout():
	color_rect.visible = false
	effect_active = false
	BoosterEvents.emit_turbo_expresso_booster_ended()
