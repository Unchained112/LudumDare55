extends Area2D

func _process(delta):
	pass
func _on_body_entered(body): ################没有实现
	print('2')
	if body.is_in_group("player"):
		print("1")
		get_leaf()

func get_leaf():
	var tween = self.create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self,"position",$"../EnergyPool".position + Vector2(-20,-40),1.0)
	await tween.finished
	add_leaf()
	
func add_leaf():
	$"../EnergyPool/Nature".value += 10
	queue_free()
	

