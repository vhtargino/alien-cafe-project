extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stage_label: Label = $StageLabel
@onready var title_label: Label = $TitleLabel

@export var stage_label_text: String
@export var title_label_text: String
@export var stage_y: float = 121
@export var title_y: float = 150


func _ready() -> void:
	stage_label.text = stage_label_text
	title_label.text = title_label_text
	
	stage_label.position.y = stage_y
	title_label.position.y = title_y
	
	get_tree().paused = true
	animation_player.play("default")
	await animation_player.animation_finished
	get_tree().paused = false
	
	self.queue_free()
