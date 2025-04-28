extends Node

@onready var timer: Timer = $Timer

var effect_active: bool = false

var label: Label
var canvas: CanvasLayer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	if label:
		label.text = str(int(timer.time_left + 1))


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("use_booster_1"):
		activate_double_shot_booster()


func activate_double_shot_booster():
	if effect_active:
		return
	
	if BoosterEvents.double_shot <= 0:
		return

	show_timer()

	effect_active = true
	BoosterEvents.double_shot -= 1
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(2.0)
	
	BoosterEvents.emit_double_shot_booster_applied()
	timer.start()


func show_timer():
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer == null:
		return
	
	label = Label.new()
	canvas = CanvasLayer.new()

	canvas.add_child(label)
	
	ui_layer.add_child(canvas)


func on_timer_timeout():
	canvas.queue_free()
	label.queue_free()
	
	effect_active = false
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	if player.has_method("set_attack_speed_multiplier"):
		player.set_attack_speed_multiplier(1.0)
