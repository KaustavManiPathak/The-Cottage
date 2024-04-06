extends CharacterBody3D

const SPEED = 1.0

#items
var reading : bool = false
var near_item : bool = false
var budy = null
var walking : bool = false
var gravity = 9.8
var disabled : bool = false
@export var level_name = "forest"
@onready var top_label = $Head/Camera3D/RayCast3D/Label2
@onready var label = $Head/Camera3D/RayCast3D/Label
@onready var SENSITIVITY = Global.sensitivity * 0.0006 #0.003
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var anim_tree = $AnimationTree

@onready var footstep1grass = load("res://audio/footstep_1_grass.wav")
@onready var footstep2grass = load("res://audio/footstep_2_grass.wav")

func _ready() -> void:
	if level_name == "forest":
		$Head/Camera3D/RayCast3D/Label2.hide()
		$Footstep1.stream = footstep1grass
		$Footstep2.stream = footstep2grass
		
	Global.game_paused = false
	$Head/Camera3D/PAUSE.enabled = false
	anim_tree.active = true
	Global.connect("sound", _sound)
	Global.connect("death", _death_handler)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _sound(a:String):
	if a == "key":
		$keys.playing = true
	elif a == "can":
		$gas_can.playing = true


func _death_handler(enemy):
	disabled = true
	head.look_at(Vector3(enemy.global_position), Vector3.UP)
	velocity = Vector3.ZERO
	anim_tree.active = false
	$AnimationPlayer.play("dying")
	


func die():
	Global.player_dead()

func _unhandled_input(event: InputEvent) -> void:
	if not disabled:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		if near_item and event.is_action_pressed("Interact"):
			if budy is Object and "open" in budy:
				budy.open =  true
				budy.open_item()
			else:
				$Head/Camera3D/RayCast3D/MeshInstance3D.hide()
				$Head/Camera3D.fov = 35
				Engine.time_scale = 0
				reading = true
				label.show()
				if budy.is_in_group("manphoto"):
					label.text = str("
I have been travelling for so long I have forgotten 
what it feels to fall in love and settle down ")
				elif budy.is_in_group("newspaper"):
					label.text = str("
Police this morning found 3 dead bodies at the cottage near the woods.
1 female and 2 male bodies were found at the scene. The female was 
found naked and left hand chopped off and hip dislocated probably
from the fall of the stairs and the person had bleed to death. 1 male 
body had the head chopped off while another had the stomach slashed
open and the insides out. Police has sealed the Cottage as of now and 
all ingress and egress into the premises is prohibited. ")
				elif budy.is_in_group("diary"):
					label.text = str("
After a long day of walking I have finally stumbled upon a cottage run by
a couple. They have given me a room upstairs to stay while the man is cooking  
dinner at the kitchen downstairs. He is a kind man and pretty welcoming. But 
what caught my attention is the wife. She is the prettiest woman I have ever
laid my eyes on. And now she is singing. Oh what a sweet voice she has. I am 
a bit drunk and I think i am attracted to her. Sounds like she is in the shower.
I can't hold myself. I must go. Its been long since I .....")
				elif budy.is_in_group("photoframe"):
					label.text = str("
Today we have started a business together. I can see
the smile in his face. He is very happy and thats all
that matters to me. I hope this works. I just want us.")
				elif budy.is_in_group("letter"):
					label.text = str("
Dear sister, business is slow these days as not many travellers
pass by in this time of the year. Today we do have a guest. Your 
brother-in-law, says we need the money but I don't trust this man.
Something seems off especially the way he keeps looking at me. I
don't feel safe with this man in the house. I hope the night is over
soon and we can be done with this man. Hope you are doing better than Iam.   
														  with love, Lily.")

func _input(event: InputEvent) -> void:
	#for Debug and testing
#	if event.is_action_pressed("exit"):
#		get_tree().quit() 
	#comment the upper line before release
	
	if not disabled:
		if event.is_action_pressed("Pause"):
			Global.game_paused = true

func _item_handler():
	if budy:
		if budy.is_in_group("key"):
			if budy.open == false:
				label.show()
				label.text = "Pickup Key"
		elif budy.is_in_group("gas_can"):
			if budy.open == false:
				label.show()
				label.text = "Pickup Fuel Can"
		elif budy.is_in_group("door"):
			if budy.open == false:
				if budy.get_parent().locked == false:
					label.show()
					label.text = "Open Door"
				else:
					label.show()
					label.text = "Door Locked, Find a key"
		elif budy.is_in_group("almirah"):
			if budy.open == false:
				if budy.get_parent().locked == false:
					label.show()
					label.text = "Open Almirah"
				else:
					label.show()
					label.text = "Almirah Locked, Find a key"
		elif budy.is_in_group("cabinet"):
			if budy.opened == false:
				label.show()
				label.text = "Open Drawer"
		elif budy.is_in_group("manphoto"):
			if not reading:
				label.show()
				label.text = "An old photo with a note"
		elif budy.is_in_group("newspaper"):
			if not reading:
				label.show()
				label.text = "An old newspaper cutout"
		elif budy.is_in_group("diary"):
			if not reading:
				label.show()
				label.text = "A diary"
		elif budy.is_in_group("photoframe"):
			if not reading:
				label.show()
				label.text = "An old photo with a note"
		elif budy.is_in_group("letter"):
			if not reading:
				label.show()
				label.text = "An unposted letter"


func _physics_process(delta: float) -> void:
	SENSITIVITY = Global.sensitivity * 0.0006
	
	if level_name == "house":
		top_label.show()
		if Global.collected < 5:
			top_label.text = "Fuel Cans Collected : " + str(Global.collected)
		else:
			top_label.text = "Exit the House"
	if not reading:
		if Global.game_paused == true:
			Engine.time_scale = 0
			$Head/Camera3D/PAUSE.show()
			$Head/Camera3D/PAUSE.enabled = true
			$Head/Camera3D/PAUSE.enabler()
		else:
			Engine.time_scale = 1
			$Head/Camera3D/PAUSE.hide()
			$Head/Camera3D/PAUSE.enabled = false
			$Head/Camera3D/PAUSE.enabler()
		
	if $Head/Camera3D/RayCast3D.is_colliding():
		near_item = true
		budy = $Head/Camera3D/RayCast3D.get_collider()
		_item_handler()
	else:
		$Head/Camera3D.fov = 75
		$Head/Camera3D/RayCast3D/MeshInstance3D.show()
		label.hide()
		near_item = false
		reading = false
	
	anim_tree.set("parameters/conditions/walk", walking)
	anim_tree.set("parameters/conditions/idle", !walking)
	
	#for waitress
	if velocity == Vector3.ZERO or not is_on_floor():
		walking = false
	else:
		walking = true
	
	#movement
	if not disabled:
		if not is_on_floor():
			velocity.y -= gravity * delta
		var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0.0
			velocity.z = 0.0
			
	_rotate_separation_ray()
	move_and_slide()
	_snap_down_to_stairs_check()

var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false

func _snap_down_to_stairs_check():
	var did_snap = false
	if not is_on_floor() and velocity.y<= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and $StairsBelowRay.is_colliding():
		walking = false
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0, max_step_down, 0)
		if PhysicsServer3D.body_test_motion(self.get_rid(),params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
		
	_was_on_floor_last_frame = is_on_floor()
	_snapped_to_stairs_last_frame = did_snap

@onready var separation_ray_dist = abs($Ray_shape_F.position.x)
func _rotate_separation_ray():
	var xz_vel = velocity * Vector3(1,0,1)
	var xz_f_ray_pos = xz_vel.normalized() * separation_ray_dist
	$Ray_shape_F.global_position.x = self.global_position.x + xz_f_ray_pos.x
	$Ray_shape_F.global_position.z = self.global_position.z + xz_f_ray_pos.z
	
	$Ray_shape_F/RayCast3D.force_raycast_update()
	var max_slope_angle_dot = Vector3(0,1,0).rotated(Vector3(1.0,0,0),self.floor_max_angle).dot(Vector3(0,1,0))
	var too_steep = false
	if $Ray_shape_F/RayCast3D.is_colliding() and $Ray_shape_F/RayCast3D.get_collision_normal().dot(Vector3(0,1,0))< max_slope_angle_dot:
		too_steep = true
	$Ray_shape_F.disabled = too_steep
	
	
	
	
	
	
#func _on_item_detect_body_entered(body: Node3D) -> void:
#	near_item = true
#	#budy = body
#
#func _on_item_detect_body_exited(body: Node3D) -> void:
#	near_item = false
#	#budy = null

