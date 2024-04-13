extends CharacterBody2D

@export var speed: int = 300

func _physics_process(delta):
	# move
	move_and_slide()
