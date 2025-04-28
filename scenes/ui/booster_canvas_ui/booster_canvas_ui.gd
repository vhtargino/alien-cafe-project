extends CanvasLayer

@onready var double_shot_booster: Node2D = $DoubleShotBooster
@onready var waker_booster: Node2D = $WakerBooster
@onready var iced_coffee_booster: Node2D = $IcedCoffeeBooster
@onready var turbo_expresso_booster: Node2D = $TurboExpressoBooster


func _ready():
	BoosterEvents.double_shot_booster_applied.connect(on_double_shot_booster_applied)
	BoosterEvents.waker_booster_applied.connect(on_waker_booster_applied)
	BoosterEvents.iced_coffee_booster_applied.connect(on_iced_coffee_booster_applied)
	BoosterEvents.turbo_expresso_booster_applied.connect(on_turbo_expresso_booster_applied)


func on_double_shot_booster_applied():
	double_shot_booster.display_timer()


func on_waker_booster_applied():
	waker_booster.display_timer()


func on_iced_coffee_booster_applied():
	iced_coffee_booster.display_timer()


func on_turbo_expresso_booster_applied():
	turbo_expresso_booster.display_timer()
