extends TextureProgressBar

@onready var health_text: Label = $Label

func _ready():
	EventBus.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(health: int):
	value = health
	# TODO: Auto get player max health
	health_text.text = "Health: " + str(health) + "/1000"
