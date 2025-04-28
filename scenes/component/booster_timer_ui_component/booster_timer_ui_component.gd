extends Node2D

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_range(458, 542, 28) var label_x
@export var base_wait_time:int = 6

var booster_active = false

var anim: Animation
var anim_library: AnimationLibrary


func _ready():
	label.set_position(Vector2(label_x, 309))
	timer.wait_time = base_wait_time
	
	anim = Animation.new()
	update_animation()
	
	if not animation_player.has_animation_library("main_library"):
		anim_library = AnimationLibrary.new()
		anim_library.add_animation("timer_default", anim)
		animation_player.add_animation_library("main_library", anim_library)
	else:
		anim_library = animation_player.get_animation_library("main_library")
		anim = anim_library.get_animation("timer_default")


func _process(_delta):
	if booster_active:
		label.text = str(int(ceil(timer.time_left)))


func display_timer():
	booster_active = true
	timer.start()
	animation_player.play("main_library/timer_default")
	label.visible = true
	
	await timer.timeout
	
	animation_player.stop()
	label.visible = false
	booster_active = false


func update_animation():
	anim.clear()
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, "../Label:position")

	anim.track_insert_key(track_index, 0.0, Vector2(label.position.x, 309))
	anim.track_insert_key(track_index, 0.1, Vector2(label.position.x, 300))
	anim.track_insert_key(track_index, 0.2, Vector2(label.position.x, 309))
	anim.loop = true
