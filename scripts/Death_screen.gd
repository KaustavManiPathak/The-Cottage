extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/house.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
