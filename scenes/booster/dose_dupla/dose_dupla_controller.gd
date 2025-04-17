extends Node

@onready var timer: Timer = $Timer

var duration: float = 8.0
var effect_active: bool = false


func _ready():
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta):
	if Input.is_action_just_pressed("use_booster_1"):
		activate_booster()


func activate_booster():
	if effect_active:
		return
	
	if GameEvents.dose_dupla <= 0:
		return
	
	GameEvents.dose_dupla -= 1

	effect_active = true
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(2.0)
	
	GameEvents.emit_dose_dupla_booster_applied(duration)
	
	timer.start(duration)


func _on_timer_timeout():
	effect_active = false
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(1.0)
