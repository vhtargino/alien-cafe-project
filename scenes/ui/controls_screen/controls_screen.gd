extends CanvasLayer
class_name ControlsScreen

signal controls_back_pressed

@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_pressed)
	back_button.focus_entered.connect(on_focus_entered)
	
	SoundUtils.enable_and_disable_focus_sound(back_button)


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_back_pressed():
	SoundUtils.play_ui_sound("button_pressed")
	controls_back_pressed.emit()
