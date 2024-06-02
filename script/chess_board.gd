extends Area2D

var global = Game
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if self.get_child_count() != 2:
				if check_possible(self):
					remove_possible_move()
					var to_remove_highlight = get_node('./' + "possible_move")
					var to_remove_piece = global.selected_node.get_child(2)
					self.remove_child(to_remove_highlight)
					create_sprite(self, global.selected_node)
					global.selected_node.remove_child(to_remove_piece)
					global.turn = "black" if global.turn == "white" else "white"
				else:
					remove_possible_move()
					possible_move(self, self.get_child(2).name.substr(5, 1))
			else:
				remove_possible_move()
				

func _on_mouse_entered():
	#print(self.name)
	pass

func remove_possible_move():
	for i in global.selected_possible_move:
		var node = get_node("../" + str(i))
		if node and node.get_child_count() > 2:
			var to_be_deleted_node = node.get_child(2)
			if to_be_deleted_node and to_be_deleted_node.name == "possible_move":
				node.remove_child(to_be_deleted_node)

func create_sprite(area, piece):
	var full_name = ""
	var color = ""
	match piece.get_child(2).name.substr(5, 1):
		"P":
			full_name = "Pawn"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"Z":
			full_name = "Knight"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"K":
			full_name = "King"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"B":
			full_name = "Bishop"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"R":
			full_name = "Rook"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"Q":
			full_name = "Queen"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
	var new_sprite = Sprite2D.new()
	var path = "res://assets/" + color + "/" + full_name + ".png"
	var new_image = load(path)
	new_sprite.texture = new_image
	new_sprite.position = Vector2(0, 0)
	new_sprite.name = global.selected_piece
	area.add_child(new_sprite)

func check_possible(area):
	for i in area.get_child_count():
		if area.get_child(i).name == "possible_move":
			return true
	return false

func possible_move(area, piece):
	if global.turn != self.get_child(2).name.substr(0, 5).to_lower():
		return
	global.selected_node = area
	global.selected_piece = area.get_child(2).name
	var piece_color = area.get_child(2).name.substr(0, 5)
	match piece.to_upper():
		"P":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var initial_row = 2 if piece_color == "White" else 7
			var is_first_move = false
			if piece_color == "White":
				is_first_move = area_index >= initial_row * 10 and area_index < (initial_row + 1) * 10
			else:
				is_first_move = area_index >= (initial_row - 1) * 10 and area_index < (initial_row + 1) * 10

			var new_area_indices = []
			if piece_color == "White":
				if is_first_move:
					new_area_indices.append(area_index + 20)
					new_area_indices.append(area_index + 10)
				else:
					new_area_indices.append(area_index + 10)
				var possible_attack = get_node('../'+str(area_index+11))
				if 3 == possible_attack.get_child_count():
					new_area_indices.append(area_index+11)
					print(possible_attack.get_child_count())
			else:
				if is_first_move:
					new_area_indices.append(area_index - 20)
					new_area_indices.append(area_index - 10)
				else:
					new_area_indices.append(area_index - 10)
			global.selected_possible_move = new_area_indices
			for new_area_index in new_area_indices:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node and new_area_node.get_child_count() == 2:  # Ensure the square is empty
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					possible_move.z_index = 10
					new_area_node.add_child(possible_move)
				else:
					print("Failed to find node for new area or the square is not empty: ", new_area_name)
					
		"Z":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var knight_moves = [
				area_index - 12, area_index - 21,
				area_index - 8, area_index - 19,
				area_index + 12, area_index + 21,
				area_index + 8, area_index + 19
			]
			global.selected_possible_move = knight_moves
			for new_area_index in knight_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node and (new_area_node.get_child_count() == 2 or new_area_node.get_child(2).name.substr(0, 5) != piece_color):
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Knight moved to ", new_area_name)
					
				else:
					print("Failed to find node for new area or it's occupied by a piece of the same color: ", new_area_name)

		"K":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var king_moves = [
				area_index - 11, area_index - 10, area_index - 9,
				area_index - 1, area_index + 1,
				area_index + 9, area_index + 10, area_index + 11
			]
			global.selected_possible_move = king_moves
			for new_area_index in king_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node and (new_area_node.get_child_count() == 2 or new_area_node.get_child(2).name.substr(0, 5) != piece_color):
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("King moved to ", new_area_name)
				else:
					print("Failed to find node for new area or it's occupied by a piece of the same color: ", new_area_name)

		"B":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-11, -9, 9, 11]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Bishop can move to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)

		"Q":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-1, 1, -10, 10, -11, -9, 9, 11]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					if direction == -1 and new_area_index % 10 == 9:
						break
					if direction == 1 and new_area_index % 10 == 0:
						break

					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Queen can move to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)

		"R":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-1, 1, -10, 10]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 77:
					if direction == -1 and new_area_index % 10 == 9:
						break
					if direction == 1 and new_area_index % 10 == 0:
						break

					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					new_area_node.add_child(possible_move)
					print("Rook can move to ", new_area_name)
				else:
					print("Failed to find node for new area: ", new_area_name)
