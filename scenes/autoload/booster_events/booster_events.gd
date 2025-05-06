extends Node

signal double_shot_booster_applied
signal waker_booster_applied
signal iced_coffee_booster_applied
signal turbo_expresso_booster_applied

signal double_shot_booster_ended
signal waker_booster_ended
signal iced_coffee_booster_ended
signal turbo_expresso_booster_ended

var double_shot: int = 5
var waker: int = 5
var iced_coffee: int = 5
var turbo_expresso: int = 5


func emit_double_shot_booster_applied():
	double_shot_booster_applied.emit()


func emit_waker_booster_applied():
	waker_booster_applied.emit()


func emit_iced_coffee_booster_applied():
	iced_coffee_booster_applied.emit()


func emit_turbo_expresso_booster_applied():
	turbo_expresso_booster_applied.emit()


func emit_double_shot_booster_ended():
	double_shot_booster_ended.emit()


func emit_waker_booster_ended():
	waker_booster_ended.emit()


func emit_iced_coffee_booster_ended():
	iced_coffee_booster_ended.emit()


func emit_turbo_expresso_booster_ended():
	turbo_expresso_booster_ended.emit()
