extends CharacterBody2D

signal enemy_die

var SPEED: int = 5
var health: int = 1000
var damage: int = 15
const KNCOKBACK = 500
var lerp_t = 0.0
var lerp_speed = 0.8

@onready var target: StaticBody2D = get_node("../Home")

func _physics_process(delta):
	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t, 0.0, 1.0)
	var new_velocity = target.position - position
	new_velocity = new_velocity.normalized() * SPEED

	velocity = velocity.lerp(new_velocity, lerp_t)
	move_and_slide()
	collision_check()

func collision_check():
	for i in get_slide_collision_count():
		#print("enemycoll")
		if i == 0: #一帧会碰撞不止一次
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			#if not collider.is_in_group("enemy"):
			if collider.is_in_group("player"):
				print("enemy position: " + str(collider.position))
				take_damage(collider.damage,collider.position)

func take_damage(damage: int,collider_position):
	#print("take")
	health -= damage
	#print(health)
	if health <= 0:
		queue_free()
		enemy_die.emit()
		return
	#print(position,collider_position)
	velocity = (position-collider_position).normalized() * KNCOKBACK * log(damage)/log(5)
	#print(velocity)
	lerp_t = 0
