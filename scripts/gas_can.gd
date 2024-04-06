extends Node3D

@export var Id : int
@export var Type : String

func _physics_process(delta: float) -> void:
	if Type == "Inside":
		$Open/CollisionShape3D.disabled = true
		if Global.open_almirah[Id]:
			$Open/CollisionShape3D.disabled =  false

