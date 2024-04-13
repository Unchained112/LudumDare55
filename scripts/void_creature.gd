extends Area2D

signal enemy_die

@export var knockback = 300
@export var speed: int = 20

var health: int = 100
var damage: int = 15
var lerp_t = 0.0
var lerp_speed = 0.8
var velocity: Vector2 = Vector2(0, 0)

@onready var target: StaticBody2D = get_node("../Home")

func _physics_process(delta):
	var new_velocity = target.position - position
	new_velocity = new_velocity.normalized() * speed

	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t, 0.0, 1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)
	position += velocity * delta

func take_damage(damage: int, collider_position):
	print("Enemy got damage: " + str(damage))
	health -= damage
	if health <= 0:
		queue_free()
		enemy_die.emit()
		return

	velocity = (position-collider_position).normalized() * knockback * log(damage)/log(5)
	lerp_t = 0

func _on_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("home"):
		body.take_damage(damage, position)
		take_damage(body.damage, body.position)