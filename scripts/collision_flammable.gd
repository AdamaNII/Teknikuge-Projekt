extends Node2D

@onready var collision_layer: TileMapLayer = get_parent().find_child("CollisionLayer")

var pos: Vector2i

func initialize_interactible(tile):
	pos = tile
	
func interact(character):
	if character.character == "fire":
		collision_layer.set_cell(pos)
		get_parent().clear_interactible(pos)
