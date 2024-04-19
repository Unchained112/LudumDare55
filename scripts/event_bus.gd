extends Node

signal pick_up_leaf(leaf, value)

signal pick_up_bone(bone, value)

signal pick_up_bonepart(bonepart)

signal enemy_created(enemy)

var is_nature_energy_full: bool = false
var is_death_energy_full: bool = false

signal player_health_changed(value)

signal game_failed
