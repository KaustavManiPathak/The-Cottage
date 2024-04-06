extends Node3D

@export var TYpe : String
var locked : bool = false

func _ready() -> void:
	if TYpe == "UG":
		locked = true

func _physics_process(delta: float) -> void:
	if TYpe == "UG" and Global.got_keys[2]:
		locked = false
	elif TYpe != "UG":
		locked = false
