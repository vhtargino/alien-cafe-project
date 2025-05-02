extends PanelContainer

signal selected

@onready var focus_player: AudioStreamPlayer = $FocusPlayer
@onready var selected_player: AudioStreamPlayer = $SelectedPlayer

@onready var ability_texture: TextureRect = %TextureRect
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var can_play_focus_sound = true


func _ready():
	gui_input.connect(on_gui_input)
	focus_mode = Control.FOCUS_ALL
	
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	
	mouse_entered.connect(on_mouse_entered)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	ability_texture.texture = upgrade.image
	name_label.text = upgrade.name.capitalize()
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		SoundUtils.play_ui_sound("button_pressed")
		SoundUtils.disable_focus_sound() # Só de segurança
		selected.emit()


func on_focus_entered():
	self.self_modulate = Color(0.8, 0.8, 0.8, 1)
	SoundUtils.play_ui_sound("focus")


func on_focus_exited():
	self.self_modulate = Color(1, 1, 1, 1)


func on_mouse_entered():
	self.grab_focus()
