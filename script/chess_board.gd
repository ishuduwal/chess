extends Area2D

const TILE_SIZE = 64
const LIGHT_COLOR = Color(1, 1, 1) # White
const DARK_COLOR = Color(0.5, 0.5, 0.5) # Grey

func _ready():
	for row in range(8):
		for col in range(8):
			var square_name = String(char(97 + col)) + str(8 - row) 
			var square = Area2D.new()
			square.name = square_name
			square.position = Vector2(col * TILE_SIZE, row * TILE_SIZE)
			
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.extents = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			collision_shape.shape = shape
			collision_shape.position = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
			square.add_child(collision_shape)
			
			var sprite = Sprite2D.new()
			var texture = ImageTexture.new()
			var image = Image.new()
			image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
			
			# Determine the color
			var color = LIGHT_COLOR if (row + col) % 2 == 0 else DARK_COLOR
			
			image.fill(color)
			texture.create_from_image(image)
			sprite.texture = texture
			square.add_child(sprite)
			
			add_child(square)
