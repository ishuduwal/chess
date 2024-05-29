extends Area2D

var global = Game

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(global.selected_node)
			if self.get_child_count() != 2:
				if check_possible(self):
					var to_remove_highlight = get_node('./'+"possible_move")
					var to_remove_piece = global.selected_node.get_child(2)
					self.remove_child(to_remove_highlight)
					create_sprite(self,global.selected_node)
					global.selected_node.remove_child(to_remove_piece)
				else:
					player_movement(self, self.get_child(2).name.substr(5, 1)) 
					
func _on_mouse_entered():
	#print(self.name)
	pass
func create_sprite(area,piece):
	var full_name = ""
	var color = ""
	print(piece.get_child(2).name.substr(5,1))
	match piece.get_child(2).name.substr(5,1):
		"P":
			full_name = "Pawn"
			color = "White" if piece.get_child(2).name.substr(0,5) == "White" else "Black"
		"Z":
			full_name = "Knight"
			color = "White" if piece.get_child(2).name.substr(0,5) == "White" else "Black"
		"K":
			full_name = "King"
			color = "White" if piece.get_child(2).name.substr(0,5) == "White" else "Black"
	var new_sprite = Sprite2D.new()
	print(color)
	print(full_name)
	var path = "res://assets/"+ color +"/"+full_name+".png"
	var new_image = load(path)  
	new_sprite.texture = new_image  
	new_sprite.position = Vector2(0, 0)
	new_sprite.name = "new_sprite"
	area.add_child(new_sprite) 
	
func check_possible(area):
	for i in area.get_child_count():
		if area.get_child(i).name == "possible_move":
			return true
	return false	

func player_movement(area, piece):
	global.selected_node = area
	print(global.selected_node.name)
	match piece:
		"P":
			# Pawn movement logic
			var area_name = str(area.name)
			var area_index = int(area_name)

			# Check if it's the first move of the pawn
			var initial_row = 2
			var is_first_move = (area_index >= initial_row * 10 and area_index < (initial_row + 1) * 10)

			var new_area_indices = []

			if is_first_move:
				new_area_indices.append(area_index + 20)  # Two steps ahead

			new_area_indices.append(area_index + 10)  # One step ahead

			for new_area_index in new_area_indices:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)

				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Pawn moved to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)

		"Z":
			var area_name = str(area.name)
			var area_index = int(area_name)
			
			var knight_moves = [
				area_index - 12, area_index - 21,
				area_index - 8, area_index - 19, 
				area_index + 12, area_index + 21, 
				area_index + 8, area_index + 19 
			]

			for new_area_index in knight_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)

				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Knight moved to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)
		"K":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var king_moves = [
				area_index - 1,   # Move left
				area_index + 1,   # Move right
				area_index - 10,  # Move up
				area_index + 10,  # Move down
			]
			for new_area_index in king_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
						var possible_move = Sprite2D.new()
						var new_image = preload("res://assets/gridsquare/predict.png")
						possible_move.texture = new_image
						possible_move.position = Vector2(0, 0)
						possible_move.name = "possible_move"
						new_area_node.add_child(possible_move)
						print("King moved to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)
		"B":
			print("Bishop moved ", area.name)
		"Q":
			print("Queen moved ", area.name)
		"R":
			print("Rook moved ", area.name)
