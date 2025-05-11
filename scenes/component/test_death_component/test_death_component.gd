extends Node2D

@export var health_component: Node
@export var animated_sprite_2d: AnimatedSprite2D

var sprite_reference = AnimatedSprite2D.new()


func _ready():
	health_component.died.connect(on_died)
	sprite_reference.sprite_frames = animated_sprite_2d.sprite_frames
	sprite_reference.offset = animated_sprite_2d.offset
	sprite_reference.visible = false
	sprite_reference.stop()


func on_died():
	if owner == null or not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	self.add_child(sprite_reference)
	sprite_reference.visible = true
	
	sprite_reference.play("death")
	await sprite_reference.animation_finished
	
	self.queue_free()
