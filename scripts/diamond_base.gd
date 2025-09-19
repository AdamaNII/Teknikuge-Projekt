extends Node

class_name Diamond

var pos: Vector2i

func initialize_interactible(tile):
	pos = tile
	
func interact(character):
	var world = get_parent()
	
	world.clear_interactible(pos)
	world.diamond_pickup()
	
