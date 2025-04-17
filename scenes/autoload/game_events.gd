extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

signal dose_dupla_booster_applied(effect_duration: float)

var dose_dupla: int = 1000
var acordador: int = 10
var cafe_gelado: int = 10
var expresso_turbo: int = 10


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_dose_dupla_booster_applied(effect_duration: float):
	dose_dupla_booster_applied.emit(effect_duration)
