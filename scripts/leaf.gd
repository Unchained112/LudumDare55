extends Area2D
class_name Leaf

var is_picked: bool = false
#var energypool = $"../CanvasLayer/EnergyPool"

func setup(pos: Vector2):
	await is_node_ready()

func _on_body_entered(body):
	if body.is_in_group("player") and not is_picked :
		EventBus.pick_up_leaf.emit(self)
		is_picked = true # Avoid double collison
