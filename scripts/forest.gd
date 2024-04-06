extends Node3D

const lines : Array[String] = [
	"
	Your brother is getting married tomorrow and 
	so you have to catch a flight in the morning.
	To save some time you took a shortcut through 
	the woods instead of the usual highway.But...",
	
	"
	Bad luck struck and now you are out of fuel 
	and you are stranded halfway through the road.
	The nearest fuel pump is 25 kms ahead at the 
	merging with the highway. What will you do?",
	
	"
	Pushing the car 25kms is madness as it will 
	be morning by the time you reach the pump and 
	you will miss the flight, which means you miss 
	the wedding. That surely cannot happen, right?",
	
	"
	Well, there is a house nearby, maybe check it 
	out if there is any fuel lying around. 5 gallons 
	should be enough to get to the nearest pump. 
	No harm in trying. Good Luck"
]
var line
@onready var textbox = $Control/TextEdit
@onready var scene = load("res://scenes/house.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.disabled = true
	line = 0
	textbox.text = lines[line]
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Forward"):
		line = line + 1
		if line >= lines.size():
			$Control.hide()
			$Player.disabled = false
		else:
			textbox.text = lines[line]


func _on_area_3d_body_entered(body: Node3D) -> void:
	$Player.disabled = true
	get_tree().change_scene_to_packed(scene)
	
