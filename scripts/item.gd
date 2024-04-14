extends Control
class_name SummonItem

@export var id: int = 0

@onready var item_bg: ColorRect = $ItemColor

func set_selected(is_selected: bool):
	if is_selected:
		item_bg.color = Color8(180, 180, 180, 60)
	else:
		item_bg.color = Color8(125, 125, 125, 60)

func _on_gui_input(event: InputEvent):
	if event.is_pressed():
		set_selected(true)
