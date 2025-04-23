extends Node

signal double_shot_booster_applied(effect_duration: float)
signal waker_booster_applied
signal iced_coffee_booster_applied
signal turbo_expresso_booster_applied

var double_shot: int = 5
var waker: int = 2
var iced_coffee: int = 2
var turbo_expresso: int = 2


func emit_double_shot_booster_applied(effect_duration: float):
	double_shot_booster_applied.emit(effect_duration)


func emit_waker_booster_applied():
	waker_booster_applied.emit()


func emit_iced_coffee_booster_applied():
	iced_coffee_booster_applied.emit()


func emit_turbo_expresso_applied():
	turbo_expresso_booster_applied.emit()
