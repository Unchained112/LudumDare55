extends CharacterBody2D

@export var speed: int = 100
@onready var target: StaticBody2D = get_node("../Home")
var health: int = 100

func _ready():	 
	add_to_group("enemies")

func _physics_process(delta):


	velocity = target.position - position 
	#print(velocity)
	velocity = velocity.normalized() * speed
	move_and_slide()

func takedamage(damage):
	health -= damage
	if health <= 0 :
		queue_free()
		remove_from_group("enemies")
		var nodes_in_group = get_tree().get_nodes_in_group("enemies")
		if nodes_in_group.empty():
			$"../RestTimer".start()
	
