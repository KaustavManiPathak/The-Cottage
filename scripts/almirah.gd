extends Node3D

@export var Id : int = 0

var locked : bool = true

func _physics_process(delta: float) -> void:
	if Global.got_keys[Id]:
		locked = false
