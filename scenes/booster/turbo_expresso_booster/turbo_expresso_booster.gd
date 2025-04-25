extends Node

@onready var timer: Timer = $Timer

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	if Input.is_action_just_pressed("use_booster_4"):
		activate_turbo_expresso_booster()


func activate_turbo_expresso_booster():
	if effect_active:
		return
	
	if BoosterEvents.turbo_expresso <= 0:
		return
	
	effect_active = true
	
	BoosterEvents.turbo_expresso -= 1
	
	BoosterEvents.emit_turbo_expresso_booster_applied()
	
	timer.start()


func on_timer_timeout():
	effect_active = false
