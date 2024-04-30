extends CharacterBody2D

const SPEED = 200.0
const KNCOKBACK = 300

@export var nature_summon_circle: PackedScene
@export var death_summon_circle: PackedScene

var health_max: int = 1000 
var health: int = 1000:
	get:
		return health
	set(value):
		health = min(health_max, value)
		health = max(0, health)
		if health == 0:
			EventBus.game_failed.emit()
		EventBus.player_health_changed.emit(health)

var damage: int = 10
var lerp_t = 1.0
var lerp_speed = 0.8
var summon_id: int = -1

@onready var screen_size = get_viewport_rect().size
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("TestAction"):
		pass

func _physics_process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var new_velocity: Vector2
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
	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t,0.0,1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)

	move_and_slide()

func take_damage(damage_got: int, collider_position):
	health -= damage_got
	velocity = (position-collider_position).normalized() * KNCOKBACK * log(damage_got)/log(5)
	lerp_t = 0

func summon(summon_scene: PackedScene, id: int):
	var new_summon = summon_scene.instantiate()
	get_parent().add_child(new_summon)
	new_summon.position = position

	# Add summon effect
	var summon_effect
	if id in range(0, 6):
		summon_effect = nature_summon_circle.instantiate()
		AudioManager.play("res://assets/audio/683184__stevenmaertens__spawning.wav")
	elif id in range(6, 11):
		summon_effect = death_summon_circle.instantiate()
		AudioManager.play("res://assets/audio/676985__stevenmaertens__spinning-short-3.wav")
	get_parent().add_child(summon_effect)
	summon_effect.position = position

func _on_game_start_summon(summon_item, id):
	summon(summon_item, id)

func _on_recover_timer_timeout():
	health += 1
