extends Node2D

var pos: Vector2i

@onready var collision_layer: TileMapLayer = get_parent().find_child("CollisionLayer")
@onready var foreground_layer: TileMapLayer = get_parent().find_child("ForegroundLayer")

var active: bool = false

func initialize_interactible(tile):
	pos = tile
	
	collision_layer.set_cell(pos, 0, Vector2i(2, 10))
	foreground_layer.set_cell(pos - Vector2i(0, 1), 0, Vector2i(2, 9))
	foreground_layer.set_cell(pos - Vector2i(0, 2), 0, Vector2i(2, 8))

func interact(character):
	var held_item = character.get_held_item()
	
	if held_item and held_item.id == "gear":
		
		active = true
		
		collision_layer.set_cell(pos, 0, Vector2i(5, 10))
		
		character.set_held_item(null)
