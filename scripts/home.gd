extends StaticBody2D

@export var damage = 10

var health_max: int = 1000
var health: int = 1000:
	get:
		return health
	set(value):
		health = min(health_max, value)
		health = max(0, health)
		if health == 0:
			EventBus.game_failed.emit()

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_text: Label = $Health

func update_health_bar():
	health_bar.value = health
	health_text.text = str(health) + "/" + str(health_max)

func take_damage(damage_got: int, _position):
	health -= damage_got
	update_health_bar()

func _on_recover_timer_timeout():
	health += 1
	update_health_bar()
