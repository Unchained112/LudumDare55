extends Node2D

signal start_summon(summon_name)

@export var summon_list: Array[PackedScene] = []
@export var max_wave: int = 3
@export var enemy_type: Array[PackedScene] = []

var summon_dict: Dictionary = {
	
}
var summon_id = 0
# enemy1, enemy2, enemy3
var wave_list = [
	[2,0,0],
	[1,1,1],
	[0,0,3]
]
var wave_cnt = 0

var cur_wave_enemy_list = []

var nature_energy_max: int = 100
var death_energy_max: int = 100
var nature_energy: int = 0
var death_energy: int = 0


@onready var wave_info: Label = $CanvasLayer/WaveInfo
@onready var rest_timer: Timer = $RestTimer
@onready var energy_pool: Control = $CanvasLayer/EnergyPool
@onready var energy_pool_pos: Vector2 = $EnergyPoolPos.position
@onready var home: StaticBody2D = $Home

func _ready(): 
	EventBus.pick_up_leaf.connect(_on_pick_up_leaf)
	EventBus.pick_up_bone.connect(_on_pick_up_bone)
	EventBus.enemy_created.connect(_on_enemy_created)
	cur_wave_enemy_list = get_enemy_list(wave_list[0])

func _input(event: InputEvent):
	if event.is_action_pressed("summon"):
		print("22")
		start_summon.emit(summon_list[summon_id])

func get_enemy_list(_wave_list) -> Array:
	var enemy_list = []
	for i in len(_wave_list):
		for j in _wave_list[i]:
			enemy_list.append(enemy_type[i])
	return enemy_list

func check_wave_end():
	var enemy_list = get_tree().get_nodes_in_group("enemy")
	if len(enemy_list) == 1 and cur_wave_enemy_list.is_empty(): # 最后一个enemy会在下一帧才移除
		rest_timer.start()

func update_nature_energy(change: int):
	nature_energy += change
	if nature_energy >= nature_energy_max:
		nature_energy = nature_energy_max
		EventBus.is_nature_energy_full = true
	if nature_energy < nature_energy_max:
		EventBus.is_nature_energy_full = false
	energy_pool.set_nature_energy(nature_energy)

func update_death_energy(change: int):
	death_energy += change
	if death_energy >= death_energy_max:
		death_energy = death_energy_max
		EventBus.is_death_energy_full = true
	if death_energy < death_energy_max:
		EventBus.is_death_energy_full = false
	energy_pool.set_death_energy(death_energy)

func _on_pick_up_leaf(leaf: Leaf):
	var tween = self.create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(leaf, "position", 
		energy_pool_pos + Vector2(-20, -40), 1.0)
	await tween.finished
	update_nature_energy(10)
	leaf.queue_free()

func _on_pick_up_bone(bone: Bone):
	var tween = self.create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(bone, "position", 
		energy_pool_pos + Vector2(20, -40), 1.0)
	await tween.finished
	update_death_energy(10)
	bone.queue_free()

func _on_enemy_created(enemy):
	enemy.set_target(home)

func _on_enemy_gen_timer_timeout():
	#print("enemy list",cur_wave_enemy_list)
	if len(cur_wave_enemy_list) > 0:
		var new_enemy = cur_wave_enemy_list.pop_front().instantiate()
		new_enemy.connect("enemy_die", check_wave_end)
		var location = $Path2D/PathFollow2D
		location.progress_ratio = randf()
		new_enemy.position = location.position
		add_child(new_enemy)

func _on_rest_timer_timeout():
	var text = wave_info.text
	var wave = int(text.split(":")[1])
	print("next wave:", wave + 1)
	if wave < max_wave :
		wave_info.text = text.split(":")[0] + ":" + str(wave + 1)
		cur_wave_enemy_list = get_enemy_list(wave_list[wave])

func _on_death_item_list_choose(choose_name):
	summon_id = choose_name
	#print("will summon:"+choose_name) # Replace with function body.

func _on_nature_item_list_choose(choose_name):
	summon_id = choose_name#print("will summon:"+choose_name)
