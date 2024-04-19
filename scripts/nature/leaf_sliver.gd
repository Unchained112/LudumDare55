extends Leaf

func _on_body_entered(body):
	is_pool_full = EventBus.is_nature_energy_full
	if body.is_in_group("player") and not is_picked and not is_pool_full:
		EventBus.pick_up_leaf.emit(self, 5)
		is_picked = true # Avoid double collison
		AudioManager.play("res://assets/audio/pickup2.wav")
