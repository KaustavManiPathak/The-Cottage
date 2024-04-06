extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@export var markers : Node3D
var marks : Array
var marks_duplicate : Array
var marker : Marker3D
var player


enum States {
	roam,
	chase,
	attack
}
var current_state
const SPEED = 1.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	anim_tree.active = true
	current_state = States.roam
	marks = markers.get_children()
	marks_duplicate = marks.duplicate()
	marker = _decide()
	
func _decide():
	if marks.is_empty():
		marks = marks_duplicate.duplicate()
	return marks.pop_front()
	
func _physics_process(delta: float) -> void:
	match current_state:
		States.roam:
			if not is_on_floor():
				velocity.y -= gravity * delta
			else:
				if marker.global_transform.origin.distance_to(global_transform.origin) < 0.1:
					velocity = Vector3.ZERO
					marker = _decide()
				else:
					look_at(Vector3( marker.global_position.x, global_position.y, marker.global_position.z),Vector3.UP)
					velocity = (marker.global_transform.origin - global_transform.origin).normalized() * SPEED
		States.chase:
			if not is_on_floor():
				velocity.y -= gravity * delta
			else:
				look_at(Vector3( player.global_position.x, global_position.y, player.global_position.z),Vector3.UP)
				velocity = (player.global_transform.origin - global_transform.origin).normalized() * SPEED
				if global_transform.origin.distance_to(player.global_transform.origin)< 1:
					current_state = States.attack
		States.attack:
			if not is_on_floor():
				velocity.y -= gravity * delta
			Global.die($face)
	anim_tree.set("parameters/conditions/chase",current_state == States.chase)
	anim_tree.set("parameters/conditions/roam",current_state == States.roam)
	move_and_slide()


func _on_eyes_body_entered(body: Node3D) -> void:
	current_state = States.chase
	player = body

func _on_eyes_body_exited(body: Node3D) -> void:
	current_state = States.roam
