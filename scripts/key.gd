extends Node3D

@export var Id : int
@export var cabinet: Node 
var oppa 

func _ready() -> void:
	if cabinet:
		$open/CollisionShape3D.disabled = true
		

func _physics_process(delta: float) -> void:
	if cabinet:
		oppa =  cabinet.get_node("open")
		if cabinet.has_key == true and oppa.opened == true and oppa.d_down == false:
			$open/CollisionShape3D.disabled  = false
			
