extends Area2D

@export var health = 100
@export var damage = 10
@export var leaf : PackedScene 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():

	var grow_up_timer = Timer.new()
	add_child(grow_up_timer)
	
	grow_up_timer.wait_time = 5.0  # 每隔1秒触发一次
	grow_up_timer.one_shot = true  # 设置为循环模式
	grow_up_timer.start()
	grow_up_timer.connect("timeout", grow_up)

# 计时器的超时处理函数
func grow_up():
	var gen_leaf_timer = Timer.new()
	add_child(gen_leaf_timer)
	
	gen_leaf_timer.wait_time = 1.0  # 每隔1秒触发一次
	gen_leaf_timer.one_shot = false  # 设置为循环模式
	gen_leaf_timer.start()	
	gen_leaf_timer.connect("timeout", gen_leaf)	


func gen_leaf():
	var new_leaf = leaf.instantiate()
	add_child(new_leaf)	
	var tween =new_leaf.create_tween().set_trans(Tween.TRANS_CUBIC)
	var new_leaf_position = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0)).normalized() * 20
	tween.tween_property(new_leaf,"position",new_leaf_position,0.5)


	
	

	
