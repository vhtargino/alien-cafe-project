extends CharacterBody2D

@onready var sprite = %PlayerSprite
@onready var healing_sprite: AnimatedSprite2D = $Visuals/HealingSprite
@onready var health_component = $HealthComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var pickup_area_collision: CollisionShape2D = $PickupArea2D/CollisionShape2D

@onready var double_shot_booster: Node = $Boosters/DoubleShotBooster
@onready var waker_booster: Node = $Boosters/WakerBooster
@onready var iced_coffee_booster: Node = $Boosters/IcedCoffeeBooster
@onready var turbo_expresso_booster: Node = $Boosters/TurboExpressoBooster

var number_colliding_bodies = 0
var colliding_bodies: Array = []

var base_speed = 0
var health_increase_percent = 1
var armor = 0

var attack_speed_multiplier: float = 1.0

var booster_speed_multiplier: float = 1.0
var upgrade_speed_multiplier: float = 1.0


func _ready():
	base_speed = velocity_component.max_speed
	
	healing_sprite.visible = false
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	$HealthRegenTimer.timeout.connect(on_health_regen_timeout)
	
	GameEvents.health_vial_collected.connect(on_health_vial_collected)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	BoosterEvents.waker_booster_applied.connect(on_waker_booster_applied)
	BoosterEvents.turbo_expresso_booster_applied.connect(on_turbo_expresso_booster_applied)
	
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


func update_speed():
	var final_speed_multiplier = upgrade_speed_multiplier * booster_speed_multiplier
	var final_speed = base_speed * final_speed_multiplier
	velocity_component.max_speed = final_speed


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func play_healing_animation():
	healing_sprite.visible = true
	healing_sprite.play("healing")
	await healing_sprite.animation_finished
	healing_sprite.visible = false


func check_deal_damage(damage: int, damage_source: Node2D):
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	
	if "is_frozen" in damage_source and damage_source.is_frozen:
		return
	
	var final_damage = max(1, damage - armor)
	
	health_component.damage(final_damage)
	GameEvents.emit_player_damaged()
	SoundUtils.play_player_sound("damage")
	damage_interval_timer.start()


func set_attack_speed_multiplier(multiplier: float):
	attack_speed_multiplier = multiplier


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	colliding_bodies.append(other_body)
	check_deal_damage(other_body.damage, other_body)


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	colliding_bodies.erase(other_body)


func on_damage_interval_timer_timeout():
	if colliding_bodies.is_empty():
		return

	var strongest_body = colliding_bodies[0]

	for body in colliding_bodies:
		if "is_frozen" in body and body.is_frozen:
			continue
		if body.damage > strongest_body.damage:
			strongest_body = body
	
	check_deal_damage(strongest_body.damage, strongest_body)


func on_health_changed():
	update_health_display()


func on_health_regen_timeout():
	if health_component.current_health == health_component.max_health:
		return
	
	health_component.current_health += 1
	update_health_display()


func on_health_vial_collected():
	var health_to_regenerate = 15
	health_component.current_health = min(health_component.max_health, (health_component.current_health + health_to_regenerate))
	update_health_display()
	play_healing_animation()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade == null:
		return
	
	if ability_upgrade is Ability:
		var _ability = ability_upgrade as Ability
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		#velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .15)
		var percent_increase = current_upgrades["player_speed"]["quantity"] * .15
		upgrade_speed_multiplier = 1.0 + percent_increase
		update_speed()
	elif ability_upgrade.id == "pickup_range":
		pickup_area_collision.shape.radius *= 1.2 # Limpar
	elif ability_upgrade.id == "player_health":
		health_component.max_health = health_component.max_health + (health_component.max_health * .15)
		health_component.current_health = health_component.current_health + (health_component.current_health * .15)
	elif ability_upgrade.id == "player_armor":
		armor += 1
	elif ability_upgrade.id == "player_regeneration":
		if current_upgrades["player_regeneration"]["quantity"] == 1:
			$HealthRegenTimer.start()
		$HealthRegenTimer.wait_time *= .9


func on_waker_booster_applied():
	var health_to_regenerate = health_component.max_health / 2
	health_component.current_health = min(health_component.max_health, (health_component.current_health + health_to_regenerate))
	update_health_display()


func on_turbo_expresso_booster_applied():
	booster_speed_multiplier = 2.0
	update_speed()
	
	await turbo_expresso_booster.timer.timeout
	
	booster_speed_multiplier = 1.0
	update_speed()
