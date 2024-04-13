extends StaticBody2D

@export var health = 1000
@export var damage = 10

func take_damage(damage: int, _position):
	print("Home got damage: " + str(damage))
	health -= damage
