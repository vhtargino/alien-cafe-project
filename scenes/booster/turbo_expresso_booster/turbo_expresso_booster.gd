extends Node

@onready var timer: Timer = $Timer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var effect_active: bool = false

#var shader_material: ShaderMaterial


func _ready():
	#shader_material = color_rect.material
	timer.timeout.connect(on_timer_timeout)
	#print(shader_material)
	#print(shader_material.get_shader_parameter("animation_speed"))


#func _process(_delta: float) -> void:
	#if get_tree().paused:
		#pass


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
