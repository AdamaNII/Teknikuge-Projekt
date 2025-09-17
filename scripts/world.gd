extends Node2D

@onready var interactibles_preset = $InteractiblesPreset
@onready var interactibles_collision = $InteractiblesCollision
@onready var interactibles_foreground = $InteractiblesForeground
@onready var collision_layer = $CollisionLayer

var interactibles: Dictionary = {}

func set_interactible(tile, atlas_position, name, id, special = {}):
	var new_interactible = {
		"name" = name,
		"id" = id,
		"atlas_position" = atlas_position,
		"can_pickup" = true
	}
	interactibles_collision.set_cell(tile, 0, atlas_position)
	
	for key in special:
		var value = special[key]
		
		if key == "can_pickup":
			new_interactible.can_pickup = value
		elif key == "interactible_object":
			var object = load(value)
			var new_interactible_object = object.instantiate()
			add_child(new_interactible_object)
			new_interactible_object.position = Vector2(tile.x * 16 + 8, tile.y * 16 + 8)
			new_interactible.interactible_object = new_interactible_object
			new_interactible_object.initialize_interactible(tile)
		elif key == "extra_tiles_foreground":
			for extra_data in value:
				interactibles_foreground.set_cell(tile + extra_data[0], 0, extra_data[1])
			
	
	interactibles[tile] = new_interactible

func clear_interactible(tile):
	interactibles_collision.set_cell(tile, 0, Vector2i(-1, -1))
	interactibles[tile] = null

func can_place_interactible(tile) -> bool:
	
	var collision_layer_data = collision_layer.get_cell_tile_data(tile)
	
	if collision_layer_data:
		if collision_layer_data.get_collision_polygons_count(0) > 0:
			return false
	
	return true

func _ready() -> void:
	for x in range(100):
		for y in range(100):
			var coords = Vector2i(x, y)
			var atlasCoords = interactibles_preset.get_cell_atlas_coords(coords)
			
			match atlasCoords:
				Vector2i(0, 0):
					set_interactible(coords, atlasCoords, "Stick", "stick")
				Vector2i(1, 0):
					set_interactible(coords, atlasCoords, "Stone", "stone")
				Vector2i(2, 0):
					set_interactible(coords, atlasCoords, "Fiber", "fiber")
			
			interactibles_preset.set_cell(coords)

func get_interactible(coords: Vector2i):	
	return interactibles.get(coords)
