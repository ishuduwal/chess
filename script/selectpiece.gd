extends Area2D

const MOVE_DISTANCE = 54 

var pawn_clicked = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var local_mouse_position = get_local_mouse_position()
		if is_mouse_inside_pawn(local_mouse_position):
			if not pawn_clicked:
				print("Pawn clicked!")
				pawn_clicked = true  
			move_pawn(local_mouse_position)
func is_mouse_inside_pawn(mouse_position):
	var pawn_rect = Rect2(position.x - 25, position.y - 25, 50, 50)  
	return pawn_rect.has_point(mouse_position)

func move_pawn(target_position):
	position = target_position
	position.y += MOVE_DISTANCE
	if position.y > get_viewport_rect().size.y:
		position.y = get_viewport_rect().size.y
		print("Invalid move") 

