extends Control

@export var id: int = 0

@onready var item_bg: ColorRect = $ItemColor

#func _on_gui_input(event: InputEvent):
	#if event.is_pressed():		
		#item_bg.color = Color8(255,215,0,30)#Color8(180, 180, 180, 60)
	#else:
		#item_bg.color = Color8(125, 125, 125, 60)
