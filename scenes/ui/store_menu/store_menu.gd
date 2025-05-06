extends CanvasLayer

@onready var double_shot_button: Button = %DoubleShotButton
@onready var waker_button: Button = %WakerButton
@onready var iced_coffee_button: Button = %IcedCoffeeButton
@onready var turbo_expresso_button: Button = %TurboExpressoButton

@onready var double_shot_held: Label = %DoubleShotHeld
@onready var waker_held: Label = %WakerHeld
@onready var iced_coffee_held: Label = %IcedCoffeeHeld
@onready var turbo_expresso_held: Label = %TurboExpressoHeld

@onready var currency_label: Label = $Control/MarginContainer/CurrencyLabel
@onready var confirmation_dialog: ConfirmationDialog = %ConfirmationDialog

@onready var credits_100_button: Button = %Credits100Button
@onready var credits_200_button: Button = %Credits200Button
@onready var credits_500_button: Button = %Credits500Button
@onready var credits_1500_button: Button = %Credits1500Button

@onready var back_button: Button = %BackButton
@onready var popup_panel: PopupPanel = %PopupPanel
@onready var h_slider: HSlider = %HSlider
@onready var slider_label: Label = %SliderLabel
@onready var quantity_ok_button: Button = %QuantityOKButton
@onready var quantity_cancel_button: Button = %QuantityCancelButton

@export var double_shot_price: int = 100
@export var waker_price: int = 100
@export var iced_coffee_price: int = 100
@export var turbo_expresso_price: int = 100

var currency_amount: int
var booster_pending: String = ""

var booster_quantity: int = 1

var booster_map = {
	"double_shot": {"price": 0, "label": null, "amount": null},
	"waker": {"price": 0, "label": null, "amount": null},
	"iced_coffee": {"price": 0, "label": null, "amount": null},
	"turbo_expresso": {"price": 0, "label": null, "amount": null},
}

var is_credit_purchase: bool = false
var pending_credit_amount: int = 0


func _ready():
	booster_map.double_shot = {"price": double_shot_price, "label": double_shot_held, "amount": BoosterEvents.double_shot}
	booster_map.waker = {"price": waker_price, "label": waker_held, "amount": BoosterEvents.waker}
	booster_map.iced_coffee = {"price": iced_coffee_price, "label": iced_coffee_held, "amount": BoosterEvents.iced_coffee}
	booster_map.turbo_expresso = {"price": turbo_expresso_price, "label": turbo_expresso_held, "amount": BoosterEvents.turbo_expresso}
	
	for key in booster_map:
		var value = BoosterEvents.get(key)
		update_held_label(booster_map[key].label, value)
	
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	double_shot_button.pressed.connect(on_double_shot_pressed)
	waker_button.pressed.connect(on_waker_pressed)
	iced_coffee_button.pressed.connect(on_iced_coffee_pressed)
	turbo_expresso_button.pressed.connect(on_turbo_expresso_pressed)
	credits_100_button.pressed.connect(on_credits_100_pressed)
	credits_200_button.pressed.connect(on_credits_200_pressed)
	credits_500_button.pressed.connect(on_credits_500_pressed)
	credits_1500_button.pressed.connect(on_credits_1500_pressed)
	back_button.pressed.connect(on_back_pressed)
	h_slider.value_changed.connect(on_h_slider_value_changed)
	quantity_ok_button.pressed.connect(on_quantity_ok_button_pressed)
	quantity_cancel_button.pressed.connect(on_quantity_cancel_button_pressed)
	
	confirmation_dialog.confirmed.connect(on_confirmed)
	
	currency_amount = StoreEvents.currency
	update_currency_label()
	
	SoundUtils.disable_focus_sound()
	double_shot_button.grab_focus()
	SoundUtils.enable_focus_sound()


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


func open_quantity_panel(booster_name: String):
	if booster_map[booster_name]["amount"] == 99:
		SoundUtils.play_ui_sound("denied")
		return
	
	var booster_data = booster_map[booster_name]
	var amount_held = booster_data["amount"]
	h_slider.max_value = 99 - amount_held
	
	booster_pending = booster_name
	h_slider.value = 1
	slider_label.text = "1"
	h_slider.grab_focus()
	popup_panel.popup_centered()


func open_credit_purchase_confirmation(money_amount: int, credit_amount: int):
	is_credit_purchase = true
	pending_credit_amount = credit_amount
	confirmation_dialog.dialog_text = "Deseja gastar R$%d para comprar %d¢?" % [money_amount, credit_amount]
	confirmation_dialog.popup_centered()


func on_double_shot_pressed():
	open_quantity_panel("double_shot")


func on_waker_pressed():
	open_quantity_panel("waker")


func on_iced_coffee_pressed():
	open_quantity_panel("iced_coffee")


func on_turbo_expresso_pressed():
	open_quantity_panel("turbo_expresso")


func on_credits_100_pressed():
	open_credit_purchase_confirmation(10, 100)


func on_credits_200_pressed():
	open_credit_purchase_confirmation(18, 200)


func on_credits_500_pressed():
	open_credit_purchase_confirmation(50, 500)


func on_credits_1500_pressed():
	open_credit_purchase_confirmation(100, 1500)


func on_h_slider_value_changed(value: float):
	booster_quantity = int(value)
	slider_label.text = "%d" % booster_quantity


func on_quantity_ok_button_pressed():
	if booster_pending == "":
		return

	var booster_data = booster_map[booster_pending]
	var price = booster_data.price
	var total_price = price * booster_quantity

	if currency_amount < total_price:
		SoundUtils.play_ui_sound("denied")
		popup_panel.hide()
		return

	is_credit_purchase = false
	confirmation_dialog.dialog_text = "Deseja gastar ¢%d para comprar %d '%s'?" % [total_price, booster_quantity, booster_pending.capitalize()]
	confirmation_dialog.popup_centered()
	popup_panel.hide()


func on_quantity_cancel_button_pressed():
	popup_panel.hide()
	booster_pending = ""
	booster_quantity = 1


func on_confirmed():
	if is_credit_purchase:
		update_currency(pending_credit_amount)
	else:
		var booster_data = booster_map[booster_pending]
		var price = booster_data.price
		var total_price = price * booster_quantity
		
		if try_purchase(total_price):
			for i in booster_quantity:
				BoosterEvents.set(booster_pending, BoosterEvents.get(booster_pending) + 1)

			update_held_label(booster_data.label, BoosterEvents.get(booster_pending))
			booster_map[booster_pending]["amount"] = BoosterEvents.get(booster_pending)

	booster_pending = ""
	booster_quantity = 1
	is_credit_purchase = false
	pending_credit_amount = 0


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_back_pressed():
	SoundUtils.disable_focus_sound()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
