extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent


func _process(_delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var enemy_position = (player_node.global_position - global_position).normalized()
		
		if global_position.x < player_node.global_position.x:
			%Sprite2D.flip_h = true
		else:
			%Sprite2D.flip_h = false
		
		return enemy_position

	return Vector2.ZERO
