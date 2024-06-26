extends Node

var items = {
	"Tree": {
		"Cost": 1,
		"ID": 0,
		"Damage": 0,
		"Health": 0,
		"Speed": 0,
		"Knockback": 0,
		"Info": "Produce leaves."
	},
	"Woodman": {
		"Cost": 20,
		"ID": 1,
		"Damage": 10,
		"Health": 100,
		"Speed": 30,
		"Knockback": 300,
		"Info": "Generate a tree every 30 seconds."
	},
	"WoodElf": {
		"Cost": 60,
		"ID": 2,
		"Damage": 50,
		"Health": 200,
		"Speed": 200,
		"Knockback": 500,
		"Info": "Increase max nature energy pool by 80."
	},
	"Bear": {
		"Cost": 100,
		"ID": 3,
		"Damage": 40,
		"Health": 400,
		"Speed": 100,
		"Knockback": 150,
		"Info": "Gain 5 more damage every 10 seconds."
	},
	"NatureDragon": {
		"Cost": 1500,
		"ID": 4,
		"Damage": 80,
		"Health": 4000,
		"Speed": 110,
		"Knockback": 90,
		"Info": "Super powerful creature."
	},
	"Grass": {
		"Cost": 1,
		"ID": 5,
		"Damage": 0,
		"Health": 0,
		"Speed": 0,
		"Knockback": 0,
		"Info": "This is life."
	},
	"Skeleton": {
		"Cost": 5,
		"ID": 6,
		"Damage": 10,
		"Health": 40,
		"Speed": 60,
		"Knockback": 300,
		"Info": "Just a normal skeleton."
	},
	"Zombie": {
		"Cost": 20,
		"ID": 7,
		"Damage": 20,
		"Health": 200,
		"Speed": 50,
		"Knockback": 200,
		"Info": "Generate a skeleton upon death."
	},
	"Ghost": {
		"Cost": 60,
		"ID": 8,
		"Damage": 50,
		"Health": 200,
		"Speed": 200,
		"Knockback": 500,
		"Info": "Increase max death energy by 80 upon death."
	},
	"Gragoyle": {
		"Cost": 100,
		"ID": 8,
		"Damage": 30,
		"Health": 800,
		"Speed": 30,
		"Knockback": 100,
		"Info": "Increase defense by 1 every 5 seconds, maximum 20."
	},
	"BoneDragon": {
		"Cost": 1000,
		"ID": 10,
		"Damage": 100,
		"Health": 2000,
		"Speed": 100,
		"Knockback": 100,
		"Info": "Very powerful creature."
	},
	"BonePart": {
		"Cost": '/',
		"ID": 11,
		"Damage": 0,
		"Health": 0,
		"Speed": 0,
		"Knockback": 0,
		"Info": "Where does death lead? Accelerate leaf generation in nearby trees."
	}
}

var tree_num: int = 0
