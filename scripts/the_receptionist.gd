extends CharacterBody3D

@export var player_near : bool = false
var marker : Marker3D
@export var player : CharacterBody3D
const SPEED = 0.8

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	if player_near == true:
		$scream.playing = true
		$OmniLight3D.light_energy = 1.5
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z),Vector3.UP)
		velocity = (player.global_transform.origin - global_transform.origin).normalized() * SPEED
		if global_transform.origin.distance_to(player.global_transform.origin)< 0.5:
			Global.die($face)
	else:
		$OmniLight3D.light_energy = 0.2
		if global_position == marker.global_position:
			velocity = Vector3.ZERO
		else:
			velocity.x = (marker.global_position.x - global_position.x) * SPEED
			velocity.z = (marker.global_position.z - global_position.z) * SPEED

	move_and_slide()
