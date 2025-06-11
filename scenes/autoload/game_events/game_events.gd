extends Node

signal experience_vial_collected(number: float)
signal health_vial_collected
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal enemy_died
signal player_damaged

var stage_1_finished: bool = false
var stage_2_finished: bool = false


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_health_vial_collected():
	health_vial_collected.emit()


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_enemy_died():
	enemy_died.emit()


func emit_player_damaged():
	player_damaged.emit()
