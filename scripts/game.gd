extends Node2D

var maxwave: int = 3
var enemy_type = ["enemy1","enemy2","enemy3","Interval?"]
var wave_list = [	
	[2,0,0,],
	[1,1,1],
	[0,0,3]
]
var this_wave_enemy_list = []
#var enemies = []

@onready var energy_pool: Label = $CanvasLayer/EnegerPool
@onready var wave_info: Label = $CanvasLayer/WaveInfo
func _ready(): 
	#wave = 1
	this_wave_enemy_list = get_enemy_list(wave_list[0])
	#enemy_list.shuffle()


func _process(delta):

	pass

func _input(event: InputEvent):
	if event.is_action_pressed("TestAction"):
		energy_pool.text = "Text Changed"
		
func get_enemy_list(wave_list):
	var enemy_list = []
	for i in len(wave_list):
		for j in wave_list[i]:
			enemy_list.append(enemy_type[i])
	return enemy_list


func _on_enemy_gen_timer_timeout():
	print("enemy list",this_wave_enemy_list)
	if len(this_wave_enemy_list) > 0:
		var new_enemy = load("res://scenes/"+this_wave_enemy_list.pop_front()+".tscn").instantiate()
		var location = $Path2D/PathFollow2D
		location.progress_ratio = randf()
		new_enemy.position = location.position
		add_child(new_enemy)

func _on_rest_timer_timeout():
	var text = wave_info.text
	var wave = int(text.split(":")[1])
	print("wave:",wave)
	if wave <= maxwave :
		wave_info.text = text.split(":")[0] + ":" + str(wave+1)
		this_wave_enemy_list = get_enemy_list(wave_list[wave])



# Replace with function body.
