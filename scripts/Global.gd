extends Node

signal death(Marker3D)

signal death_screen
signal cans_collected
signal sound(String)
var game_paused : bool = false
var sensitivity = 5

var collected : int  = 0
var open_almirah : Array = [false, false]
var got_keys : Array = [false, false, false]


func die(global_position):
	emit_signal("death",global_position)
func player_dead():
	emit_signal("death_screen")

func key_sound():
	emit_signal("sound", "key")

func collection():
	collected += 1
	emit_signal("sound", "can")
	if collected == 5:
		emit_signal("cans_collected")
	
