extends Node

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_3"):
		activate_iced_coffee_booster()


func activate_iced_coffee_booster():
	if effect_active:
		return
	
	if BoosterEvents.iced_coffee <= 0:
		return
	
	animation_player.play("flash")
	SoundUtils.play_booster_sound("iced_coffee")
	
	effect_active = true
	BoosterEvents.iced_coffee -= 1
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies == null:
		return
	
	for enemy in enemies:
		if enemy.has_method("freeze"):
			enemy.freeze()
	
	BoosterEvents.emit_iced_coffee_booster_applied()
	timer.start()


func on_timer_timeout():
	effect_active = false
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies == null:
		return
	
	for enemy in enemies:
		if enemy.has_method("unfreeze"):
			enemy.unfreeze()
	
	BoosterEvents.emit_iced_coffee_booster_ended()
