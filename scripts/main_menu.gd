extends Node3D

func _ready() -> void:
	Engine.time_scale = 1
	$AnimationPlayer.play("lightning")
	$Camera3D/Control/ColorRect.hide()
	$Camera3D/Control/ColorRect/VBoxContainer/HBoxContainer/BACK.disabled = true
	$Camera3D/Control/ColorRect/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.editable = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/forest.tscn")

func _on_controls_pressed() -> void:
	$Camera3D/Control/BOXContainer.hide()
	$Camera3D/Control/THE.hide()
	$Camera3D/Control/COTTAGE.hide() 
	$Camera3D/Control/AGAMEBY.hide()
	$Camera3D/Control/BOXContainer/PLAY.disabled = true
	$Camera3D/Control/BOXContainer/CONTROLS.disabled = true
	$Camera3D/Control/BOXContainer/QUIT.disabled = true
	
	$Camera3D/Control/ColorRect.show()
	$Camera3D/Control/ColorRect/VBoxContainer/HBoxContainer/BACK.disabled = false
	$Camera3D/Control/ColorRect/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.editable = true
	$Camera3D/Control/ColorRect/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.set_value_no_signal(5)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	$Camera3D/Control/BOXContainer.show()
	$Camera3D/Control/THE.show()
	$Camera3D/Control/COTTAGE.show()
	$Camera3D/Control/AGAMEBY.show()
	$Camera3D/Control/BOXContainer/PLAY.disabled = false
	$Camera3D/Control/BOXContainer/CONTROLS.disabled = false
	$Camera3D/Control/BOXContainer/QUIT.disabled = false
	
	$Camera3D/Control/ColorRect.hide()
	$Camera3D/Control/ColorRect/VBoxContainer/HBoxContainer/BACK.disabled = true
	$Camera3D/Control/ColorRect/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.editable = false


func _on_h_slider_value_changed(value: float) -> void:
	Global.sensitivity = value
