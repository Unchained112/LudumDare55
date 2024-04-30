extends Node2D

signal start_summon(summon_name, id)

@export var summon_list: Array[PackedScene] = []
#按照表里的顺序的召唤物花费
@export var summon_cost: Array[int] = [1,20,60,100,1500,1,
										5,20,60,100,1000,0]
#@export var summon_cost: Array[int] = [1,1,1,1,1,1,1,1,1,1,1,1] #for test
#@export var max_wave: int = 3
@export var enemy_type: Array[PackedScene] = []

var summon_dict: Dictionary = {
	
}
var summon_id = 0
# enemy1, enemy2, elite, boss
var wave_list = [
	[1,0,0,0],
	[2,0,0,0],
	[2,1,0,0],
	[3,1,0,0],
	[5,0,0,0],#5
	[5,3,0,0],
	[5,5,0,0],
	[0,10,0,0],
	[10,10,0,0],
	[5,5,1,0],#10
	[10,10,1,0],
	[30,10,1,0],
	[30,10,2,0],
	[15,15,3,0],
	[0,30,4,0],#15
	[10,10,5,0],
	[10,10,8,0],
	[0,0,10,0],
	[10,10,15,0],
	[0,0,0,1]#20
]
var max_wave = len(wave_list)
var wave_cnt = 0

var cur_wave_enemy_list = []

var nature_energy_max: int = 100
var death_energy_max: int = 100
var nature_energy: int = 0
var death_energy: int = 0
var score: int = 0
var is_paused: bool = false

@onready var wave_info: Label = $CanvasLayer/WaveInfo
@onready var score_info: Label = $CanvasLayer/ScoreInfo
@onready var rest_timer: Timer = $RestTimer
@onready var energy_pool: Control = $CanvasLayer/EnergyPool
@onready var energy_pool_pos: Vector2 = $EnergyPoolPos.position
@onready var bonepart_pos: Vector2 = $"CanvasLayer/DeathItemList".position
@onready var home: StaticBody2D = $Home
@onready var settings: TabContainer = $CanvasLayer/PausePanel/Settings
@onready var pause_panel: Panel = $CanvasLayer/PausePanel
@onready var fail_panel: Panel = $CanvasLayer/FailPanel
@onready var win_panel: Panel = $CanvasLayer/WinPanel

func _ready():
	EventBus.pick_up_leaf.connect(_on_pick_up_leaf)
	EventBus.pick_up_bone.connect(_on_pick_up_bone)
	EventBus.pick_up_bonepart.connect(_on_pick_up_bonepart)
	EventBus.enemy_created.connect(_on_enemy_created)
	EventBus.game_failed.connect(_on_game_fail)
	cur_wave_enemy_list = get_enemy_list(wave_list[0])

func _input(event: InputEvent):
	if event.is_action_pressed("Summon"):
		var this_summon_cost = summon_cost[summon_id]

		if summon_id in range(0, 6):
			if nature_energy >= this_summon_cost:
				update_nature_energy(-this_summon_cost)
				start_summon.emit(summon_list[summon_id], summon_id)
				if summon_id == 0:
					GameData.tree_num += 1
				if summon_id == 2:
					nature_energy_max += 80
					energy_pool.set_nature_max_energy(nature_energy_max)

		elif  summon_id in range(6, 11):
			if death_energy >= this_summon_cost:
				update_death_energy(-this_summon_cost)
				start_summon.emit(summon_list[summon_id], summon_id)
				if summon_id == 8:
					death_energy_max += 80
					energy_pool.set_death_max_energy(death_energy_max)
					
	if event.is_action_pressed("Escape"):
		if not pause_panel.visible:
			pause_game()
		else:
			resume_game()

func pause_game():
	pause_panel.show()
	reset_focus()
	Engine.time_scale = 0

func resume_game():
	Engine.time_scale = 1
	pause_panel.hide()

func reset_focus():
	$CanvasLayer/PausePanel/PauseMenu/Resume.grab_focus()

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
	score += change
	score_info.text = 'Score: ' + str(score)
	if nature_energy >= nature_energy_max:
		nature_energy = nature_energy_max
		EventBus.is_nature_energy_full = true
	if nature_energy < nature_energy_max:
		EventBus.is_nature_energy_full = false
	energy_pool.set_nature_energy(nature_energy)

func update_death_energy(change: int):
	death_energy += change
	score += change
	score_info.text = 'Score: ' + str(score)
	if death_energy >= death_energy_max:
		death_energy = death_energy_max
		EventBus.is_death_energy_full = true
	if death_energy < death_energy_max:
		EventBus.is_death_energy_full = false
	energy_pool.set_death_energy(death_energy)

func game_win():
	win_panel.show()
	Engine.time_scale = 0

func _on_pick_up_leaf(leaf: Leaf, value: int):
	var tween = self.create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(leaf, "position", 
		energy_pool_pos + Vector2(-20, -40), 1.0)
	tween.tween_callback(leaf.queue_free)
	update_nature_energy(value)

func _on_pick_up_bone(bone: Bone, value: int):
	var tween = self.create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(bone, "position", 
		energy_pool_pos + Vector2(20, -40), 1.0)
	tween.tween_callback(bone.queue_free)
	update_death_energy(value)

func _on_pick_up_bonepart(bonepart: Bonepart):
	await  bonepart.effect_player.animation_finished
	bonepart.queue_free()

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
	# TODO: Better game win condition check
	if wave == max_wave:
		game_win()
	if wave < max_wave :
		wave_info.text = text.split(":")[0] + ":" + str(wave + 1)
		cur_wave_enemy_list = get_enemy_list(wave_list[wave])

func _on_death_item_list_choose(choose_name):
	summon_id = choose_name

func _on_nature_item_list_choose(choose_name):
	summon_id = choose_name

func _on_resume_pressed():
	resume_game()

func _on_option_pressed():
	settings.show()
	settings.reset_focus()

func _on_main_menu_pressed():
	resume_game()
	Utilities.switch_scene("MainMenu", self)
	AudioManager.stop_music()

func _on_game_fail():
	fail_panel.show()
	Engine.time_scale = 0
