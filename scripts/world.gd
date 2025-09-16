extends Node2D

@onready var interactibles_preset = $InteractiblesPreset
@onready var interactibles_collision = $InteractiblesCollision
@onready var collision_layer = $CollisionLayer

var interactibles: Dictionary = {}

func set_interactible(tile, atlas_position, name, id):
	interactibles[tile] = {
		Name = name,
		Id = id,
		AtlasPosition = atlas_position
	}
	interactibles_collision.set_cell(tile, 0, atlas_position)

func clear_interactible(tile):
	interactibles[tile] = null
	interactibles_collision.set_cell(tile, 0, Vector2i(-1, -1))

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
