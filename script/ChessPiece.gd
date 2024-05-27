extends Area2D

const TILE_SIZE = 64
const WHITE_TILE_TEXTURE = preload("res://assets/gridsquare/white.png")
const BLACK_TILE_TEXTURE = preload("res://assets/gridsquare/black.png")

func _ready():
	for i in range(8):
		for j in range(8):
			var square_name = String(char(97 + j)) + str(8 - i)
			var square = Area2D.new()
			square.name = square_name
			square.position = Vector2(j * TILE_SIZE, i * TILE_SIZE)
			
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.extents = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			collision_shape.shape = shape
			collision_shape.position = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			square.add_child(collision_shape)
			
			var sprite = Sprite2D.new()  
			var texture = WHITE_TILE_TEXTURE if (i + j) % 2 == 0 else BLACK_TILE_TEXTURE
			sprite.texture = texture
			sprite.scale = Vector2(TILE_SIZE / float(texture.get_width()), TILE_SIZE / float(texture.get_height()))
			square.add_child(sprite)
			
			add_child(square)
