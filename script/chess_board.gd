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
		"B":
			full_name = "Bishop"
			color = "White" if piece.get_child(2).name.substr(0,5) == "White" else "Black"
		"R":
			full_name = "Rook"
			color = "White" if piece.get_child(2).name.substr(0,5) == "White" else "Black"
		"Q":
			full_name = "Queen"
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

func is_blocked(piece, new_area_node):
	if new_area_node:
		if new_area_node.get_child_count() > 0:
			if piece.get_child(2).name.substr(0,5) != new_area_node.get_child(0).name.substr(0,5):
				return false
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
			var color = area.get_child(2).name.substr(0,5)
			# Check if it's the first move of the pawn
			var initial_row = 2 if color == "White" else 7
			var is_first_move = false
			if color == "White":
				is_first_move = area_index >= initial_row * 10 and area_index < (initial_row + 1) * 10
			else:
				is_first_move = area_index >= (initial_row - 1) * 10 and area_index < initial_row * 10

			print("Pawn color: ", color)
			print("Initial row: ", initial_row)
			print("Is first move: ", is_first_move)
			print("Area index: ", area_index)

			var new_area_indices = []
			if color == "White":
				if is_first_move:
					new_area_indices.append(area_index + 20)  # Two steps ahead
					new_area_indices.append(area_index + 10)  # One step ahead
				else:
					if is_first_move:
						new_area_indices.append(area_index -20)
						new_area_indices.append(area_index - 10)
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
					area_index - 11, # Move up-left
					area_index - 10, # Move up
					area_index - 9,  # Move up-right
					area_index - 1,  # Move left
					area_index + 1,  # Move right
					area_index + 9,  # Move down-left
					area_index + 10, # Move down
					area_index + 11 # Move down-right
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
			# Bishop movement logic
			var area_name = str(area.name)
			var area_index = int(area_name)

			# Define diagonal directions
			var directions = [-11, -9, 9, 11]

			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						var possible_move = Sprite2D.new()
						var new_image = preload("res://assets/gridsquare/predict.png")
						possible_move.texture = new_image
						possible_move.position = Vector2(0, 0)
						possible_move.name = "possible_move"
						new_area_node.add_child(possible_move)
						print("Bishop possible move to ", new_area_name)
					else:
						print("Failed to find node for new area: ", new_area_name)
					new_area_index += direction
					
		"Q":
			var area_name = str(area.name)
			var area_index = int(area_name)
			
			# Define all possible directions for the Queen
			var directions = [-1, 1, -10, 10, -11, -9, 9, 11]

			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					# Ensure queen does not wrap around horizontally
					if direction == -1 and new_area_index % 10 == 9:  # Moved from 10 to 9 (invalid)
						break
					if direction == 1 and new_area_index % 10 == 0:  # Moved from 9 to 10 (invalid)
						break

					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node and not is_blocked(piece, new_area_node):
						var possible_move = Sprite2D.new()
						var new_image = preload("res://assets/gridsquare/predict.png")
						possible_move.texture = new_image
						possible_move.position = Vector2(0, 0)
						possible_move.name = "possible_move"
						new_area_node.add_child(possible_move)
						print("Queen possible move to ", new_area_name)
					else:
						print("Failed to find node for new area or path is blocked: ", new_area_name)
					new_area_index += direction
		"R":
			# Rook movement logic
			var area_name = str(area.name)
			var area_index = int(area_name)

			# Define rook movement directions: left, right, up, down
			var directions = [-1, 1, -10, 10]

			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					# Ensure rook does not wrap around horizontally
					if direction == -1 and new_area_index % 10 == 9:  # Moved from 10 to 9 (invalid)
						break
					if direction == 1 and new_area_index % 10 == 0:  # Moved from 9 to 10 (invalid)
						break

					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						var possible_move = Sprite2D.new()
						var new_image = preload("res://assets/gridsquare/predict.png")
						possible_move.texture = new_image
						possible_move.position = Vector2(0, 0)
						possible_move.name = "possible_move"
						new_area_node.add_child(possible_move)
						print("Rook possible move to ", new_area_name)
					else:
						print("Failed to find node for new area: ", new_area_name)
					new_area_index += direction
