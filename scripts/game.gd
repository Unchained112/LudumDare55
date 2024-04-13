extends Node2D

var level: int = 0
var enemy_list

@onready var energy_pool: Label = $CanvasLayer/EnegerPool

func _ready(): 
	pass # Replace with function body.

func _process(delta):
	pass

func _input(event: InputEvent):
	if event.is_action_pressed("TestAction"):
		energy_pool.text = "Text Changed"
