extends CharacterBody2D

@export var damage: int = 20
@export var health: int = 100
@export var speed = 60.0
@export var knockback = 300
@export var drop_leaves: int = 0
@export var drop_bones: int = 0
@export var drop_boneparts: int = 0
@export var leaf : PackedScene
@export var bone : PackedScene
@export var bonepart : PackedScene

var lerp_t = 1.0
var lerp_speed = 0.8

func _ready():
	var grow_up_timer = Timer.new()
	add_child(grow_up_timer)
	
	grow_up_timer.wait_time = 10  
	grow_up_timer.one_shot = false  
	grow_up_timer.start()
	grow_up_timer.connect("timeout", grow_up)

# 计时器的超时处理函数
func grow_up():
	damage += 5
	speed += 5
	
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
		var homes = get_tree().get_nodes_in_group("home")
		for home in homes:
			new_velocity = home.position - position
			new_velocity = new_velocity.normalized() * speed

	lerp_t += lerp_speed * delta
	lerp_t = clamp(lerp_t,0.0,1.0)
	velocity = velocity.lerp(new_velocity, lerp_t)
	move_and_slide()

func take_damage(damage_got: int, collider_position):
	health -= damage_got
	if health <= 0:
		call_deferred("drop") # TODO: Need to check if this works
		queue_free()		
	velocity = (position-collider_position).normalized() * knockback * log(damage_got)/log(5)
	lerp_t = 0

func drop():
	for i in range(1, drop_bones + 1):
		var new_bone = bone.instantiate()
		get_parent().add_child(new_bone)
		new_bone.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5, 30 + Utilities.calcualte_range_num(i))

	for i in range(1, drop_leaves + 1):
		var new_leaf = leaf.instantiate()
		get_parent().add_child(new_leaf)
		new_leaf.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5, 30 + Utilities.calcualte_range_num(i))

	for i in range(1, drop_boneparts + 1):
		var new_bonepart = bonepart.instantiate()
		get_parent().add_child(new_bonepart)
		new_bonepart.position = position + Vector2(randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)) * randi_range(5, 30 + Utilities.calcualte_range_num(i))
