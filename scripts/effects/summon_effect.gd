extends Sprite2D

@onready var effect_player: AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready():
	effect_player.play("Summon")

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
