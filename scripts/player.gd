extends CharacterBody2D

const SPEED = 200.0
const KNCOKBACK = 300

var health: int = 1000
var damage: int = 10
var lerp_t = 1.0
var lerp_speed = 0.8

@onready var screen_size = get_viewport_rect().size
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta):
	#print(position)
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var new_velocity :Vector2
	if direction:
		new_velocity.x = direction.x * SPEED
		new_velocity.y = direction.y * SPEED
	else:
		new_velocity.x = move_toward(new_velocity.x, 0, SPEED)
		new_velocity.y = move_toward(new_velocity.y, 0, SPEED)
	
	if new_velocity.length() > 0:
		animation_player.play("Move")
	else:
		animation_player.play("Idle")
		
	new_velocity = new_velocity.normalized() * SPEED		
	lerp_t += lerp_speed * _delta
	lerp_t = clamp(lerp_t,0.0,1.0)
	velocity = velocity.lerp(new_velocity,lerp_t)
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	collision_check()
	move_and_slide()

	
func collision_check():
	for i in get_slide_collision_count():
		if i == 0: 
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider and collider.is_in_group("enemy"):
				#print("enemy position: " + str(collider.position))
				take_damage(collider.damage,collider.position)

			
func take_damage(damage: int,collider_position):
	health -= damage
	print("player health: " + str(health))
	velocity = (position-collider_position).normalized() * KNCOKBACK * log(damage)/log(5)
	lerp_t = 0
