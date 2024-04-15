extends Area2D
class_name Bonepart

var is_picked: bool = false
var is_pool_full: bool = false

func _on_body_entered(body):
	if body.is_in_group("player") and not is_picked:
		EventBus.pick_up_bonepart.emit(self)
		is_picked = true # Avoid double collison
		AudioManager.play("res://assets/audio/pickupBone.wav")
