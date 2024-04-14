extends HBoxContainer
signal choose(choose_name)

@export var default_color: Color = Color8(120, 120, 120, 60)
@export var highlight_color: Color = Color8(180, 180, 180, 120)

# 保存上次点击的节点
var last_clicked_node = null

func _ready():
	# 连接所有 Label 节点的 "mouse_entered" 信号到 _on_label_mouse_entered 函数
	for child in get_children():
		if child is Control:
			child.connect("gui_input",_on_choose.bind(child))
			#print(child,"connect")

# 当 Label 节点被点击时调用的函数
func _on_choose(event: InputEvent,control):
	if event.is_pressed():
		#print("choose")
		choose.emit(control.id)
		# 如果上次点击的节点存在，恢复它的原始颜色
		if last_clicked_node and last_clicked_node != control:
			last_clicked_node.get_node("ItemColor").color = default_color
		
		# 设置当前点击的节点为金色
		control.get_node("ItemColor").color = highlight_color
		last_clicked_node = control  # 更新上次点击的节点为当前节点

func _on_death_item_list_choose(_choose_name):
	if last_clicked_node:
		last_clicked_node.get_node("ItemColor").color = default_color
		last_clicked_node = null
