extends Control

@export var item_name: String = "Tree"
@export var id: int = 0

@onready var item_bg: ColorRect = $ItemColor
@onready var item_cost: Label = $Cost
# TODO: Fix info text under other images
@onready var item_info: Control = $ItemInfo

func _ready():
	item_cost.text = str(GameData.items[item_name]["Cost"])
	item_info.setup(item_name)

func set_item_info():
	item_info.show()
	item_info.position = get_local_mouse_position()
	item_info.position.y -= 180

func _on_mouse_entered():
	set_item_info()

func _on_mouse_exited():
	item_info.hide()

func _on_item_color_mouse_entered():
	set_item_info()

func _on_item_color_mouse_exited():
	item_info.hide()
