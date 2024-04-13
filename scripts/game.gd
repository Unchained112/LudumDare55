extends Node2D

@export var summon_list: Array[PackedScene] = []
@export var max_wave: int = 3
@export var enemy_type: Array[PackedScene] = []


var summon_dict: Dictionary = {
	
}
# enemy1, enemy2, enemy3
var wave_list = [
	[2,0,0],
	[1,1,1],
	[0,0,3]
]
var wave_cnt = 0

var cur_wave_enemy_list = []

@onready var energy_pool: Label = $CanvasLayer/EnegerPool
@onready var wave_info: Label = $CanvasLayer/WaveInfo
@onready var rest_timer: Timer = $RestTimer

func _ready(): 
	cur_wave_enemy_list = get_enemy_list(wave_list[0])

func _input(event: InputEvent):
	if event.is_action_pressed("TestAction"):
		energy_pool.text = "Text Changed"

func get_enemy_list(wave_list) -> Array:
	var enemy_list = []
	for i in len(wave_list):
		for j in wave_list[i]:
			enemy_list.append(enemy_type[i])
	return enemy_list

func check_wave_end():
	var enemy_list = get_tree().get_nodes_in_group("enemy")
	if len(enemy_list) == 1 and cur_wave_enemy_list.is_empty(): # 最后一个enemy会在下一帧才移除
		rest_timer.start()

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
