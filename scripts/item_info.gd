extends Control

@onready var info_label: Label = $Panel/InfoLabel

func setup(item_name: String):
	var data = GameData.items[item_name]
	info_label.text = ""
	info_label.text += "Health: " + str(data["Health"]) + "\n"
	info_label.text += "Damage: " + str(data["Damage"]) + "\n"
	info_label.text += "Speed: " + str(data["Speed"]) + "\n"
	#info_label.text += "Knockback: " + str(data["Knockback"]) + "\n"
	info_label.text += "Info: " + data["Info"]
