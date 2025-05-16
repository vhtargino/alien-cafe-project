extends Node

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var effect_active: bool = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_1"):
		activate_double_shot_booster()


func activate_double_shot_booster():
	if effect_active:
		return
	
	if BoosterEvents.double_shot <= 0:
		return
	
	animation_player.play("flash")
	SoundUtils.play_double_shot_sound()

	effect_active = true
	BoosterEvents.double_shot -= 1
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(2.0)
	
	BoosterEvents.emit_double_shot_booster_applied()
	timer.start()


func on_timer_timeout():
	effect_active = false
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(1.0)
	
	BoosterEvents.emit_double_shot_booster_ended()
