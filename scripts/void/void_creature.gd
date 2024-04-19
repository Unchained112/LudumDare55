extends Area2D

signal enemy_die
@export var damage: int = 15
@export var health: int = 10
@export var speed: int = 20
@export var knockback = 300
@export var drop_leaves: int = 3
@export var drop_bones: int = 5
@export var drop_boneparts: int = 10
@export var leaf : PackedScene = load("res://scenes/nature/leaf.tscn")
@export var bone : PackedScene = load("res://scenes/death/bone.tscn")
@export var leaf_sliver : PackedScene = load("res://scenes/nature/leaf_sliver.tscn")
@export var bone_sliver : PackedScene = load("res://scenes/death/bone_sliver.tscn")
@export var leaf_gold : PackedScene = load("res://scenes/nature/leaf_gold.tscn")
@export var bone_gold : PackedScene = load("res://scenes/death/bone_gold.tscn")
@export var bonepart : PackedScene = load("res://scenes/death/bonepart.tscn")



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
	#print("Enemy got damage: " + str(damage_got))
	health -= damage_got
	if health <= 0:
		AudioManager.play("res://assets/audio/676477__stevenmaertens__beast-breath.wav")
		call_deferred("drop") # TODO: Need to check if this works
		queue_free()
		enemy_die.emit()
		return
	velocity = (position-collider_position).normalized() * knockback * log(damage_got)/log(5)
	lerp_t = 0

func drop():
	var count = 1
	while drop_bones > 0 :
		if drop_bones > 25:
			drop_item(bone_gold, count)
			drop_bones -= 25
			count += 1
		if drop_bones > 5:
			drop_item(bone_sliver, count)
			drop_bones -= 5
			count += 1
		if drop_bones > 0:
			drop_item(bone, count)
			drop_bones -= 1
			count += 1
	count = 1

	while drop_leaves > 0 :
		if drop_leaves > 25:
			drop_item(leaf_gold, count)
			drop_leaves -= 25
			count += 1
		if drop_leaves > 5:
			drop_item(leaf_sliver, count)
			drop_leaves -= 5
			count += 1
		if drop_leaves > 0:
			drop_item(leaf, count)
			drop_leaves -= 1
			count += 1

func drop_item(item, count):
	var new_item = item.instantiate()
	get_parent().add_child(new_item)
	new_item.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5, 30 + Utilities.calcualte_range_num(count))

func _on_body_entered(body):
	if (body.is_in_group("player") or 
		body.is_in_group("player_team") or 
		body.is_in_group("home")):
		body.take_damage(damage, position)
		take_damage(body.damage, body.position)
		AudioManager.play("res://assets/audio/hitHurt1.wav")
