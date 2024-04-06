extends Node3D

@export var has_key : bool = false
@export var key_id : int
@onready var key = $key

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if has_key == true:
		if key != null:
			key.show()
			key.Id = key_id
