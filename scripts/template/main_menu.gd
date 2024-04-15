extends Control

@onready var option_menu: TabContainer = $"../Settings"

func _ready():
	$VBoxContainer/Start.grab_focus()
	var taiji = $taiji
	var tween = taiji.create_tween().set_trans(Tween.TRANS_LINEAR).set_loops()
	tween.tween_property(taiji, "rotation",  -180 , 500)
	tween.tween_property(taiji, "rotation",  0 , 500)
	var taiji2 = $taiji2
	var tween2 = taiji2.create_tween().set_trans(Tween.TRANS_LINEAR).set_loops()
	tween2.tween_property(taiji2, "rotation",  -180 , 500)
	tween2.tween_property(taiji2, "rotation",  0 , 500)


func reset_focus():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	Utilities.switch_scene("SampleGame", self)
	AudioManager.play_music_sound()

func _on_option_pressed():
	option_menu.show()
	option_menu.reset_focus()
	AudioManager.play_button_sound()

func _on_quit_pressed():
	get_tree().quit()
