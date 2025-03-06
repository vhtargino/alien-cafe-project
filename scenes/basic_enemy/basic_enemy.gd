extends CharacterBody2D

const MAX_SPEED = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var enemy_position = (player_node.global_position - global_position).normalized()
		
		if global_position.x < player_node.global_position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		
		return enemy_position

	return Vector2.ZERO


func on_area_entered(other_area: Area2D):
	queue_free()
