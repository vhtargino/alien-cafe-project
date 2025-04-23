extends CharacterBody2D

@onready var sprite = %PlayerSprite
@onready var health_component = $HealthComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var pickup_area_collision: CollisionShape2D = $PickupArea2D/CollisionShape2D

var number_colliding_bodies = 0
var colliding_bodies: Array = []

var base_speed = 0
var health_increase_percent = 1
var regeneration_amount = 0
var armor = 0
var attack_speed_multiplier: float = 1.0


func _ready():
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	$HealthRegenTimer.timeout.connect(on_health_regen_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(_delta: float):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 or movement_vector.y != 0:
		sprite.play("player_walk")
	else:
		sprite.play("player_idle")

	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func check_deal_damage(damage: int):
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	
	var final_damage = max(1, damage - armor)
	
	health_component.damage(final_damage)
	damage_interval_timer.start()


func set_attack_speed_multiplier(multiplier: float):
	attack_speed_multiplier = multiplier


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	colliding_bodies.append(other_body)
	check_deal_damage(other_body.damage)


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	colliding_bodies.erase(other_body)


func on_damage_interval_timer_timeout():
	if colliding_bodies.is_empty():
		return

	var strongest_body = colliding_bodies[0]

	for body in colliding_bodies:
		if body.damage > strongest_body.damage:
			strongest_body = body
	
	check_deal_damage(strongest_body.damage)


func on_health_changed():
	update_health_display()


func on_health_regen_timeout():
	if health_component.current_health == health_component.max_health:
		return
	
	health_component.current_health += regeneration_amount
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade == null:
		return
	
	if ability_upgrade is Ability:
		var _ability = ability_upgrade as Ability
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .15)
	elif ability_upgrade.id == "pickup_range":
		pickup_area_collision.shape.radius *= 1.2 # Limpar
	elif ability_upgrade.id == "player_health":
		health_component.max_health = health_component.max_health + (health_component.max_health * .15)
		health_component.current_health = health_component.current_health + (health_component.current_health * .15)
	elif ability_upgrade.id == "player_armor":
		armor += 1
	elif ability_upgrade.id == "player_regeneration":
		regeneration_amount += 1
