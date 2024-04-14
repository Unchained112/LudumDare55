extends CharacterBody2D

@export var speed = 60.0
@export var knockback = 300

var health: int = 100
var damage: int = 20
var lerp_t = 1.0
var lerp_speed = 0.8

func _physics_process(delta):
	var new_velocity = Vector2(0, 0)

	var enemy_list = get_tree().get_nodes_in_group("enemy")
	var target_enemy = null
	var max_dist: float = INF
	for enemy in enemy_list:
		var dis = position.distance_squared_to(enemy.position)
		if dis < max_dist:
			target_enemy = enemy
			max_dist = dis

	if target_enemy:
		new_velocity = target_enemy.position - position
		new_velocity = new_velocity.normalized() * speed

	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t,0.0,1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)
	move_and_slide()

func take_damage(damage_got: int, collider_position):
	health -= damage_got
	print("Skeleton health: " + str(health))
	velocity = (position-collider_position).normalized() * knockback * log(damage_got)/log(5)
	lerp_t = 0
