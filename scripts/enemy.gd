extends CharacterBody2D

signal enemy_die

@export var speed: int = 100

var health: int = 100
var damage: int = 10

@onready var target: StaticBody2D = get_node("../Home")

func _physics_process(delta):
	velocity = target.position - position 
	velocity = velocity.normalized() * speed
	move_and_slide()

func take_damage(damage):
	health -= damage
	if health <= 0 :
		queue_free()
		enemy_die.emit()
