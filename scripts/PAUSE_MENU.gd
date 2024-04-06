extends ColorRect

var enabled : bool = false
var sensitivty : float

func enabler():
	sensitivty = Global.sensitivity
	$Control/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.set_value_no_signal(sensitivty)
	
	if enabled == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$Control/VBoxContainer/HBoxContainer/RESUME.disabled = true
		$Control/VBoxContainer/HBoxContainer/BACK.disabled = true
		$Control/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.editable =  false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		$Control/VBoxContainer/HBoxContainer/RESUME.disabled = false
		$Control/VBoxContainer/HBoxContainer/BACK.disabled = false
		$Control/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.editable = true


func _on_back_pressed() -> void:
	Global.game_paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_resume_pressed() -> void:
	Global.game_paused = false


func _on_h_slider_value_changed(value: float) -> void:
	Global.sensitivity = value
	
