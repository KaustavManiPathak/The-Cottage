extends Node3D

var gasoline = load("res://scenes/gas_can.tscn")
var waitress_scene = load("res://scenes/the_waitress.tscn")
var keyy = load("res://scenes/key.tscn")

@onready var cab_1 = $First_Floor_items/cabinet
@onready var cab_2 = $First_Floor_items/cabinet2
@onready var key_markers = $key_markers
@onready var reciptionist = $the_receptionist

func _ready() -> void:
	Global.connect("cans_collected", _cans)
	Global.connect("death_screen", _dead)
	$AnimationPlayer.play("start_level")
	$Exit/CollisionShape3D.disabled = true
	$Player.disabled = false
	randomize()
	select_reciptionist()
	


func _dead():
	print("pai golu")
	$Player.queue_free()
	get_tree().change_scene_to_file("res://scenes/Death_screen.tscn")

func _cans():
	$Exit/CollisionShape3D.disabled = false

func select_f_gas_cans():
	var markers = [1,2,3,4,5,6]
	for n in 3:
		markers.shuffle()
		var target = markers.pop_front()
		var gas_can = gasoline.instantiate()
		#var target : int = randi_range(1,6)
		if target == 1:
			gas_can.Id = $First_Floor_items/almirah.Id
			gas_can.Type = "Inside"
		elif target == 6:
			gas_can.Id = $First_Floor_items/almirah2.Id
			gas_can.Type = "Inside"
		var ab = $F_Floor.get_node(str(target))
		gas_can.global_position = ab.global_position
		gas_can.scale = Vector3 (0.2, 0.2, 0.2)
		add_child(gas_can)
	
func select_g_gas_cans():
	var markers = [1,2,3]
	markers.shuffle()
	var target = markers.pop_front()
	var gas_can = gasoline.instantiate()
	var ab = $G_Floor.get_node(str(target))
	gas_can.global_position = ab.global_position
	gas_can.scale = Vector3 (0.2, 0.2, 0.2)
	add_child(gas_can)

func select_reciptionist():
	var markers = [1,2,3,4]
	markers.shuffle()
	var target = markers.pop_front()
	var ab = $receipt_markerts.get_node(str(target))
	reciptionist.marker = ab
	
	
func select_keys():
	var markers = [1,2,5,3,4,6]
	for n in 3:
		markers.shuffle()
		var target = markers.pop_front()
		var key = keyy.instantiate()
		if target in [1,2,5,4]:
			var ab = $key_markers.get_node(str(target))
			key.Id = n
			key.global_position = ab.global_position
			key.rotation.z = 90
			key.scale = Vector3 (0.1, 0.1, 0.1)
			add_child(key)
		elif target == 3:
			cab_1.key_id = n
			cab_1.has_key = true
		elif target == 6:
			cab_2.key_id = n
			cab_2.has_key = true

func select_waitress_spawn():
	var markers = [1,2,3,4]
	markers.shuffle()
	var target = markers.pop_front()
	var waitress = waitress_scene.instantiate()
	var ab = $waitress_points.get_node(str(target))
	var loc = $waitress_p_s2.get_node(str(target))
	waitress.p_loc = loc.global_position 
	waitress.player = $Player
	waitress.global_position = ab.global_position
	waitress.scale = Vector3 (0.35, 0.35, 0.35)
	add_child(waitress)
	$waitress_timer.start()

func _on_exit_body_entered(body: Node3D) -> void:
	$Control.show()
	$AnimationPlayer.play("stop_level")
	


func _on_ug_enter_body_entered(body: Node3D) -> void:
	$Ground_Floor_Items.hide()
	$the_cook.hide()
	reciptionist.player_near = true

func _on_ug_enter_body_exited(body: Node3D) -> void:
	$the_cook.show()
	$Ground_Floor_Items.show()
	reciptionist.player_near = false


func _on_g_stairs_body_entered(body: Node3D) -> void:
	$the_cook.show()
	$Ground_Floor_Items.show()
	$First_Floor_items.hide()
	
func _on_f_stairs_body_entered(body: Node3D) -> void:
	$the_cook.hide()
	$Ground_Floor_Items.hide()
	$First_Floor_items.show()


func _on_waitress_timer_timeout() -> void:
	select_waitress_spawn()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_level":
		Global.collected = 0
		Global.got_keys = [false, false, false]
		Global.open_almirah = [false, false]
		select_f_gas_cans()
		select_g_gas_cans()
		select_keys()
		select_waitress_spawn()
		$Control.hide()
	if anim_name == "stop_level":
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
