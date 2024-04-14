extends Control

@onready var nature_bar: TextureProgressBar = $Nature
@onready var death_bar: TextureProgressBar = $Death
@onready var nature_value: Label = $NatureValue
@onready var death_value: Label = $DeathValue

func set_nature_energy(energy: int):
	nature_bar.value = energy

func set_death_energy(energy: int):
	death_bar.value = energy

func set_nature_max_energy(energy: int):
	nature_bar.max_value = energy
	
func set_death_max_energy(energy: int):
	death_bar.max_value = energy

func _on_nature_value_changed(value):
	nature_value.text = str(nature_bar.value) + '\n' + "leaves"

func _on_death_value_changed(value):
	death_value.text = str(death_bar.value) + '\n' + "bones"
