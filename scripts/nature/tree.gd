extends Area2D

@export var damage = 10
@export var health = 100
@export var leaf: PackedScene
@export var leaf_sliver: PackedScene
@export var gen_leaf_timer: Timer

var cd_reduced: int = 0

func _ready():
	gen_leaf_timer.connect("timeout", gen_leaf)

func gen_leaf():
	if GameData.tree_num < 50:
		gen_leaf_timer.wait_time = max(15 - cd_reduced, 10)
	else:
		gen_leaf_timer.wait_time = max(75.0 - cd_reduced, 50)
		leaf = leaf_sliver
	var new_leaf = leaf.instantiate()
	# Add to the secen to avoid being delete when tree is deleted
	get_parent().add_child(new_leaf)
	new_leaf.position = position
	var tween = new_leaf.create_tween().set_trans(Tween.TRANS_CUBIC)
	var new_leaf_position = position + Vector2(randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)) * 20
	tween.tween_property(new_leaf, "position", new_leaf_position, 0.5)
