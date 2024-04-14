extends Sprite2D

@onready var effect_player: AnimationPlayer = $AnimationPlayer

func play():
	effect_player.play("Move")

func stop():
	effect_player.stop()
