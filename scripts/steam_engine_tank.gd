extends Node2D

var pos: Vector2i

@onready var collision_layer: TileMapLayer = get_parent().find_child("CollisionLayer")
@onready var foreground_layer: TileMapLayer = get_parent().find_child("ForegroundLayer")

var water_level: int = 0

func update_tank(section_0: bool = false, section_1: bool = false, section_2: bool = false):
	if section_0:
		collision_layer.set_cell(pos, 0, Vector2i(3, 10))
	else:
		collision_layer.set_cell(pos, 0, Vector2i(0, 10))
		
	if section_1:
		foreground_layer.set_cell(pos - Vector2i(0, 1), 0, Vector2i(3, 9))
	else:
		foreground_layer.set_cell(pos - Vector2i(0, 1), 0, Vector2i(0, 9))
		
	if section_2:
		foreground_layer.set_cell(pos - Vector2i(0, 2), 0, Vector2i(3, 8))
	else:
		foreground_layer.set_cell(pos - Vector2i(0, 2), 0, Vector2i(0, 8))

func initialize_interactible(tile):
	pos = tile
	
	update_tank()

func interact(character):
	if character.character == "water":
		water_level = clamp(water_level + 1, 0, 2)
		
		match water_level:
			0:
				update_tank()
			1:
				update_tank(true)
			2:
				update_tank(true, true, true)
		
		
