extends Control

@onready var nature_bar: TextureProgressBar = $Nature
@onready var death_bar: TextureProgressBar = $Death

func set_nature_energy(energy: int):
	nature_bar.value = energy

func set_death_energy(energy: int):
	death_bar.value = energy
