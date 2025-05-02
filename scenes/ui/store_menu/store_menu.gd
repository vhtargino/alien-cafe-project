extends CanvasLayer

@onready var double_shot_button: SoundButton = %DoubleShotButton
@onready var waker_button: SoundButton = %WakerButton
@onready var iced_coffee_button: SoundButton = %IcedCoffeeButton
@onready var turbo_expresso_button: SoundButton = %TurboExpressoButton
@onready var back_button: SoundButton = %BackButton

@onready var double_shot_held: Label = %DoubleShotHeld
@onready var waker_held: Label = %WakerHeld
@onready var iced_coffee_held: Label = %IcedCoffeeHeld
@onready var turbo_expresso_held: Label = %TurboExpressoHeld

@onready var currency_label: Label = $Control/MarginContainer/CurrencyLabel
@onready var confirmation_dialog: ConfirmationDialog = %ConfirmationDialog

@export var double_shot_price: int = 100
@export var waker_price: int = 100
@export var iced_coffee_price: int = 100
@export var turbo_expresso_price: int = 100

var currency_amount: int
var booster_pending: String = ""

var booster_map = {
	"double_shot": { "price": 0, "label": null },
	"waker": { "price": 0, "label": null },
	"iced_coffee": { "price": 0, "label": null },
	"turbo_expresso": { "price": 0, "label": null },
}


func _ready():
	booster_map.double_shot = { "price": double_shot_price, "label": double_shot_held }
	booster_map.waker = { "price": waker_price, "label": waker_held }
	booster_map.iced_coffee = { "price": iced_coffee_price, "label": iced_coffee_held }
	booster_map.turbo_expresso = { "price": turbo_expresso_price, "label": turbo_expresso_held }
	
	for key in booster_map:
		var value = BoosterEvents.get(key)
		update_held_label(booster_map[key].label, value)

	double_shot_button.pressed.connect(on_double_shot_pressed)
	waker_button.pressed.connect(on_waker_pressed)
	iced_coffee_button.pressed.connect(on_iced_coffee_pressed)
	turbo_expresso_button.pressed.connect(on_turbo_expresso_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	confirmation_dialog.confirmed.connect(on_confirmed)
	
	currency_amount = StoreEvents.currency
	update_currency_label()

	double_shot_button.grab_focus()


func update_currency_label():
	currency_label.text = "¢: %d" % currency_amount


func update_held_label(label: Label, amount: int):
	label.text = "Held: %d" % amount


func update_currency(amount: int):
	currency_amount += amount
	StoreEvents.currency = currency_amount
	update_currency_label()


func try_purchase(price: int):
	if currency_amount < price:
		return false
	
	update_currency(-price)
	return true


func purchase_booster(booster_name: String):
	var booster_data = booster_map[booster_name]
	var price = booster_data.price
	if try_purchase(price):
		BoosterEvents.set(booster_name, BoosterEvents.get(booster_name) + 1)
		update_held_label(booster_data.label, BoosterEvents.get(booster_name))


func confirm_booster(booster_name: String):
	var booster_data = booster_map[booster_name]
	var price = booster_data.price
	
	var current_amount = BoosterEvents.get(booster_name)
	if current_amount >= 99:
		return
	
	if currency_amount < price:
		return

	booster_pending = booster_name
	confirmation_dialog.dialog_text = "Deseja gastar ¢%d para comprar '%s'?" % [price, booster_name.capitalize()]
	confirmation_dialog.popup_centered()


func on_double_shot_pressed():
	confirm_booster("double_shot")


func on_waker_pressed():
	confirm_booster("waker")


func on_iced_coffee_pressed():
	confirm_booster("iced_coffee")


func on_turbo_expresso_pressed():
	confirm_booster("turbo_expresso")


func on_confirmed():
	if booster_pending != "":
		purchase_booster(booster_pending)
		booster_pending = ""


func on_back_pressed():
	get_tree().get_root().set_disable_input(true)
	await SoundUtils.check_button_sound_playing(back_button)
	get_tree().get_root().set_disable_input(false)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
