extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var experience_amount: float

var alternative_experience_vial_2 = preload("res://assets/experience_pod/experience_pod_c2.png")
var alternative_experience_vial_3 = preload("res://assets/experience_pod/experience_pod_c3.png")


func _ready():
	change_sprite()
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func disable_collision():
	collision_shape_2d.disabled = true


func collect():
	SoundUtils.play_experience_sound()
	GameEvents.emit_experience_vial_collected(experience_amount)
	queue_free()


func change_sprite():
	if experience_amount < 4:
		return
	
	if experience_amount < 7:
		sprite.texture = alternative_experience_vial_2
	else:
		sprite.texture = alternative_experience_vial_3


func on_area_entered(_other_area: Area2D):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(.45)
	tween.chain()
	tween.tween_callback(collect)
