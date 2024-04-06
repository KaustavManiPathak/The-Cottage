extends CharacterBody3D

@onready var anim_tree = $AnimationTree

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 10.0

enum States {
	appear,
	land,
	roam,
	attack
}
var currentState : States
@export var player : CharacterBody3D
var p_cam
@export var p_loc : Vector3

func _ready() -> void:
	currentState = States.appear
	anim_tree.active = true
	if player:
		p_cam = player.get_node("Head").get_child(0)
	
var near : bool = false

func _physics_process(delta: float) -> void:
	anim_tree.set("parameters/conditions/stand", currentState == States.land)
	anim_tree.set("parameters/conditions/walk", currentState == States.roam)
	anim_tree.set("parameters/conditions/ceiling", currentState == States.appear)
	
	if player:
		look_at(Vector3( player.global_position.x, global_position.y, player.global_position.z),Vector3.UP)
	
	match currentState:
		States.appear:
			if not is_on_ceiling():
				velocity.y += gravity * delta
			if player:
				if player.global_position.distance_to(p_loc)<1:
					currentState = States.land
		States.land:
			currentState = States.roam
		States.roam:
			if not is_on_floor():
				velocity.y -= gravity * delta
			if not near:
				currentState = States.land
				
			if global_transform.origin.distance_to(player.global_transform.origin) < 0.5:
				currentState = States.attack
			else:
				velocity = (p_cam.global_transform.origin - global_transform.origin).normalized() * SPEED
		States.attack:
			velocity = Vector3.ZERO
			Global.die($face)

	move_and_slide()

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
