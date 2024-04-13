extends StaticBody2D

@export var health = 1000
@export var damage = 10

func take_damage(damage_got: int, _position):
	print("Home got damage: " + str(damage_got))
	health -= damage_got
