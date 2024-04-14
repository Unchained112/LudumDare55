extends Area2D

signal enemy_die

@export var knockback = 300
@export var speed: int = 20
@export var leaf : PackedScene
@export var bone : PackedScene

var health: int = 10
var damage: int = 15
var drop_leaves: int = 3
var drop_bones: int = 5
var lerp_t = 0.0
var lerp_speed = 0.8
var velocity: Vector2 = Vector2(0, 0)
var target: StaticBody2D

func _ready():
	EventBus.enemy_created.emit(self)

func _physics_process(delta):
	var new_velocity = target.position - position
	new_velocity = new_velocity.normalized() * speed

	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t, 0.0, 1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)
	position += velocity * delta

func set_target(_target: StaticBody2D):
	target = _target

func take_damage(damage_got: int, collider_position):
	print("Enemy got damage: " + str(damage_got))
	health -= damage_got
	if health <= 0:
		call_deferred("drop") # TODO: Need to check if this works
		queue_free()
		enemy_die.emit()
		return
	velocity = (position-collider_position).normalized() * knockback * log(damage_got)/log(5)
	lerp_t = 0

func drop():
	for i in range(1, drop_bones + 1):
		var new_bone = bone.instantiate()
		get_parent().add_child(new_bone)
		new_bone.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5,30+10*log(i)/log(5))

	for i in range(1, drop_leaves + 1):
		var new_leaf = leaf.instantiate()
		get_parent().add_child(new_leaf)
		new_leaf.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5,30+10*log(i)/log(5))

func _on_body_entered(body):
	if (body.is_in_group("player") or 
		body.is_in_group("player_team") or 
		body.is_in_group("home")):
		body.take_damage(damage, position)
		take_damage(body.damage, body.position)