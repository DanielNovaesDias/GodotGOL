extends Resource

class_name Cell

var is_alive := false
var neighbors_count := 0


func update_alive_status():
	if neighbors_count == 3 && !is_alive:
		is_alive = true
	elif (neighbors_count > 3 || neighbors_count < 2) && is_alive:
		is_alive = false
		
	neighbors_count = 0
