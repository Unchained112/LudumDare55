extends CharacterBody2D

const SPEED = 300.0

var health: int = 1000

@onready var screen_size = get_viewport_rect().size
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.length() > 0:
		animation_player.play("Move")
	else:
		animation_player.play("Idle")

	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			print("enemy position: " + str(collider.position))
			take_damage(collider.damage)

func take_damage(damage: int):
	health -= damage
	print("player health: " + str(health))
