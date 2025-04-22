extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

signal double_shot_booster_applied(effect_duration: float)

var double_shot: int = 5
var waker: int = 2
var iced_coffee: int = 2
var turbo_expresso: int = 2


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_double_shot_booster_applied(effect_duration: float):
	double_shot_booster_applied.emit(effect_duration)
