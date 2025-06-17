extends CanvasLayer

@onready var stage_1_button: Button = %Stage1Button
@onready var stage_2_button: Button = %Stage2Button
@onready var stage_3_button: Button = %Stage3Button
@onready var back_button: Button = %BackButton

@export var stage_1_scene: PackedScene
@export var stage_2_scene: PackedScene
@export var stage_3_scene: PackedScene
@export var main_menu_scene: PackedScene


func _ready():
	for button in get_tree().get_nodes_in_group("ui_buttons"):
		button.focus_entered.connect(on_focus_entered)
		button.pressed.connect(on_button_pressed)
	
	stage_1_button.pressed.connect(on_stage_1_pressed)
	stage_2_button.pressed.connect(on_stage_2_pressed)
	stage_3_button.pressed.connect(on_stage_3_pressed)
	back_button.pressed.connect(on_back_pressed)
	
	check_stage_finished()
	
	SoundUtils.enable_and_disable_focus_sound(stage_1_button)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(main_menu_scene)


func check_stage_finished():
	if GameEvents.stage_1_finished == true:
		stage_2_button.disabled = false
	
	if GameEvents.stage_2_finished == true:
		stage_3_button.disabled = false


func on_focus_entered():
	SoundUtils.play_ui_sound("focus")


func on_button_pressed():
	SoundUtils.play_ui_sound("button_pressed")


func on_stage_1_pressed():
	get_tree().change_scene_to_packed(stage_1_scene)


func on_stage_2_pressed():
	get_tree().change_scene_to_packed(stage_2_scene)


func on_stage_3_pressed():
	get_tree().change_scene_to_packed(stage_3_scene)


func on_back_pressed():
	SoundUtils.disable_focus_sound()
	get_tree().change_scene_to_packed(main_menu_scene)
