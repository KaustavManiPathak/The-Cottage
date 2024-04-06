extends Node3D

const lines : Array[String] = [
	"
	You filled your car with the 5 gallons of fuel 
	that you found in the haunted house. It wasn't 
	an easy task, but you did it. You can now make
	it to the wedding and also have a story to tell.",
	
	"
	'I Thank you from the bottom of my heart for 
	playing the game. From programming to modelling 
	to audio & mixing, everything was done solely by 
	me. I hope it was worth your time'.  - The Solo Dev
	"
]
var tt = true
var line : int
@onready var textbox = $Control/TextEdit
var text_gone :bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Control/TextEdit3.hide()
	$Control/TextEdit.hide()
	$Control/TextEdit2.hide()
	line = 0
	textbox.text = lines[line]
	$AnimationPlayer.play("going")
	$AnimationPlayer2.play("open")
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Forward"):
		line = line + 1
		if line >= lines.size():
			$Control/TextEdit.hide()
			$Control/TextEdit2.hide()
			$Control/TextEdit3.show()
			text_gone = true
		else:
			textbox.text = lines[line]
	if text_gone and Input.is_action_just_pressed("Backward"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		$Control/TextEdit.show()
		$Control/TextEdit2.show()
