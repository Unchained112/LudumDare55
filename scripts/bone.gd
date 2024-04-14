extends Area2D
class_name Bone

var is_picked: bool = false
var is_pool_full: bool = false

func _on_body_entered(body):
	is_pool_full = EventBus.is_death_energy_full
	if body.is_in_group("player") and not is_picked and not is_pool_full:
		EventBus.pick_up_bone.emit(self)
		is_picked = true # Avoid double collison
