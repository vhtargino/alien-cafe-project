extends CharacterBody2D

var character_speed = 80

#var horizontal_queue = []
#var vertical_queue = []

@onready var sprite = %PlayerSprite

func _process(_delta: float) -> void:
	var movement_vector = get_movement_vector()
	velocity = movement_vector.normalized() * character_speed
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		sprite.play("player_walk")
	else:
		sprite.play("player_idle")
		
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false
	
	return Vector2(x_movement, y_movement)


#func get_movement_vector() -> Vector2:
	## Atualiza filas removendo teclas soltas e adicionando novas pressionadas
	#horizontal_queue = horizontal_queue.filter(Input.is_action_pressed)
	#vertical_queue = vertical_queue.filter(Input.is_action_pressed)
#
	#for action in ["move_right", "move_left"]:
		#if Input.is_action_just_pressed(action):
			#horizontal_queue.append(action)
#
	#for action in ["move_down", "move_up"]:
		#if Input.is_action_just_pressed(action):
			#vertical_queue.append(action)
#
	#if vertical_queue or horizontal_queue:
		#sprite.play("player_walk")
	#else:
		#sprite.play("player_idle")
		#
	#if horizontal_queue and horizontal_queue[-1] == "move_left":
		#sprite.flip_h = true
	#if horizontal_queue and horizontal_queue[-1] == "move_right":
		#sprite.flip_h = false
#
	## Define os valores diretamente, eliminando verificações desnecessárias
	#var x_input = 1 if horizontal_queue and horizontal_queue[-1] == "move_right" else -1 if horizontal_queue else 0
	#var y_input = 1 if vertical_queue and vertical_queue[-1] == "move_down" else -1 if vertical_queue else 0
#
	#
	#return Vector2(x_input, y_input)
