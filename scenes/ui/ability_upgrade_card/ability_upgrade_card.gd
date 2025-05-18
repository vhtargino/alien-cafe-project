extends PanelContainer

signal selected

@onready var ref_rect_animation_player: AnimationPlayer = $RefRectAnimationPlayer
@onready var new_label_animation_player: AnimationPlayer = $NewLabelAnimationPlayer
@onready var ability_texture: TextureRect = %TextureRect
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var new_label: Label = $MarginContainer/VBoxContainer/NewLabel
@onready var reference_rect: ReferenceRect = $ReferenceRect

var can_play_focus_sound = true


func _ready():
	reference_rect.visible = false
	gui_input.connect(on_gui_input)
	focus_mode = Control.FOCUS_ALL
	
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	
	mouse_entered.connect(on_mouse_entered)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	ability_texture.texture = upgrade.image
	name_label.text = upgrade.name #.capitalize()
	description_label.text = upgrade.description
	if upgrade.sub_type == "weapon_main" or upgrade.sub_type == "power_up_main":
		new_label.visible = true
	else:
		new_label.text = ""


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		SoundUtils.play_ui_sound("button_pressed")
		SoundUtils.disable_focus_sound() # Só de segurança
		selected.emit()


func on_focus_entered():
	#self.self_modulate = Color(0.8, 0.8, 0.8, 1)
	reference_rect.visible = true
	#ref_rec_animation_player.play("default")
	SoundUtils.play_ui_sound("focus")


func on_focus_exited():
	reference_rect.visible = false
	#ref_rec_animation_player.stop()
	#self.self_modulate = Color(1, 1, 1, 1)


func on_mouse_entered():
	self.grab_focus()
