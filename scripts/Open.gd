extends StaticBody3D
@export var type : String = "objname"
var opened = false
var d_down = false
var open = false
@onready var anim_plyer = $AnimationPlayer

func open_item():
	if open and not opened:
		match type:
			"drawer":
				anim_plyer.play("drawer_down_open")
			"gas_can":
				Global.collection()
				get_parent().queue_free()
			"almirah":
				if get_parent().locked == false:
					anim_plyer.play("door_open")
					var a = get_parent().Id
					Global.open_almirah[a] = true
					$CollisionShape3D3.disabled = true
					$CollisionShape3D2.disabled = true
				else:
					open = false
			"door":
				if get_parent().locked == false:
					anim_plyer.play("door_open")
					$CollisionShape3D.disabled = true
				else:
					open = false
			"keys":
				var a = get_parent().Id
				Global.got_keys[a] = true
				Global.key_sound()
				get_parent().queue_free()
	if open and d_down:
		anim_plyer.play("drawer_up_open")
	
#func _physics_process(delta: float) -> void:
#	if open not opened:
#		match type:
#			"drawer":
#				anim_plyer.play("drawer_down_open")
#			"gas_can":
#				Global.collection()
#				get_parent().queue_free()
#			"almirah":
#				if get_parent().locked == false:
#					anim_plyer.play("door_open")
#					var a = get_parent().Id
#					Global.open_almirah[a] = true
#					$CollisionShape3D3.disabled = true
#					$CollisionShape3D2.disabled = true
#				else:
#					open = false
#			"door":
#				if get_parent().locked == false:
#					anim_plyer.play("door_open")
#					$CollisionShape3D.disabled = true
#				else:
#					open = false
#			"keys":
#				var a = get_parent().Id
#				Global.got_keys[a] = true
#				get_parent().queue_free()
#	if open and d_down:
#		anim_plyer.play("drawer_up_open")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "door_open":
		open = false
		opened = true
	if anim_name == "drawer_down_open":
		open = false
		opened = true
		d_down = true
	if anim_name == "drawer_up_open":
		open = false
		d_down = false


