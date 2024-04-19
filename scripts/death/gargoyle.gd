extends CharacterBody2D

@export var damage: int = 20
@export var health: int = 100
@export var speed = 60.0
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

var def = 0
var lerp_t = 1.0
var lerp_speed = 0.8

func _ready():
	var grow_up_timer = Timer.new()
	add_child(grow_up_timer)
	
	grow_up_timer.wait_time = 5  
	grow_up_timer.one_shot = false  
	grow_up_timer.start()
	grow_up_timer.connect("timeout", grow_up)

# 计时器的超时处理函数
func grow_up():
	if def < 20: 
		def += 1
	
func _physics_process(delta):
	var new_velocity = Vector2(0, 0)

	var enemy_list = get_tree().get_nodes_in_group("enemy")
	var target_enemy = null
	var max_dist: float = INF
	for enemy in enemy_list:
		var dis = position.distance_squared_to(enemy.position)
		if dis < max_dist:
			target_enemy = enemy
			max_dist = dis

	if target_enemy:
		new_velocity = target_enemy.position - position
		new_velocity = new_velocity.normalized() * speed
	else:
		var players = get_tree().get_nodes_in_group("player")
		for player in players:
			new_velocity = player.position - position
			if new_velocity.length() > 70:
				new_velocity = new_velocity.normalized() * speed
			else: new_velocity = Vector2(0,0)

	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t,0.0,1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)
	move_and_slide()

func take_damage(damage_got: int, collider_position):
	health -= max(damage_got-def,1)
	if health <= 0:
		call_deferred("drop") # TODO: Need to check if this works
		queue_free()
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
