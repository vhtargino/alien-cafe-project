extends Node

@onready var timer: Timer = $Timer

var duration: float = 5.0
var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	if Input.is_action_just_pressed("use_booster_3"):
		activate_iced_coffee_booster()


func activate_iced_coffee_booster():
	if effect_active:
		return
	
	if BoosterEvents.iced_coffee <= 0:
		return
	
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
