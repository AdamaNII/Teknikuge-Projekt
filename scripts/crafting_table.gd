extends Node2D

var pos: Vector2i
var focused_slot: Vector2i = Vector2i(0, 0)

var occupied: bool = false
var occupant: String = ""
var occupant_object

var recipes_path: String = "res://resources/recipes"

var recipes_loaded: Array = []

var content: Dictionary = {
	"0" = {},
	"1" = {},
	"2" = {},
}

func initialize_interactible(tile: Vector2i):
	pos = tile

var interact_delay = 5
var interact_counter = 0

func load_recipes():
	var recipe_files: Array = []
	var dir = DirAccess.open(recipes_path)
	dir.list_dir_begin()
	
	for file in dir.get_files():
		var recipe_string = FileAccess.get_file_as_string(dir.get_current_dir() + "/" + file)

		var json = JSON.new()
		var recipe_dict: Dictionary = json.parse_string(recipe_string)
		
		var recipe: Dictionary = {
			pattern = {},
			result = recipe_dict.result,
			height = recipe_dict.pattern.size()
		}
		
		var i: int = 0
		
		for row: String in recipe_dict.pattern:
			recipe.pattern[i] = {}
			
			if !recipe.has("width"):
				recipe.width = row.length()
			elif row.length() != recipe.width:
				print("Mismatched row lengths in recipe " + file + ".")
			
			
			var j: int = 0
			
			for pattern_key: String in row.split():
				if pattern_key != " ":
					if recipe_dict.key.has(pattern_key):
						recipe.pattern[i][j] = recipe_dict.key[pattern_key]
					else:
						print("Unable to find key \"" + pattern_key + "\" in recipe " + file + ".")
				else:
					recipe.pattern[i][j] = ""
				j += 1
			i += 1
		
		recipes_loaded.append(recipe)
		

func get_sub_content(start_x, start_y, size_x, size_y):
	var sub_content = {}
	
	for i in range(size_y):
		sub_content[str(i)] = {}
		
		for j in range(size_x):
			sub_content[str(i)][str(j)] = content[str(start_y + i)][str(start_x + j)]
			
	return sub_content

func match_recipe(target, recipe) -> bool:
	for row in recipe.pattern:
		
		for key in recipe.pattern[row]:
			var value = recipe.pattern[row][key]
			var target_slot = target[str(row)][str(key)]
			
			if value == "" and target_slot == null:
				continue
			
			if value == "" and target_slot != null:
				return false
			
			if value != "" and target_slot == null:
				return false
			
			if target_slot.id != value:
				return false
			
	return true

func check_empty_negative(start_x, start_y, size_x, size_y):
	for i in range(3):
		for j in range(3):
			if !(start_x <= i and start_x + (size_x - 1) >= i) or !(start_y <= j and start_y + (size_y - 1) >= j):
				if content[str(j)][str(i)] != null:
					return false
	
	return true
	

func get_result():
	for recipe in recipes_loaded:
		for i in range(4 - recipe.height):
			for j in range(4 - recipe.width):
				var sub_content = get_sub_content(j, i, recipe.width, recipe.height)
				
				var is_recipe = match_recipe(sub_content, recipe)
				
				if is_recipe:
					var excess_slots_empty = check_empty_negative(j, i, recipe.width, recipe.height)
					
					if excess_slots_empty:
						var result = recipe.result
						var atlas_pos = result.atlas_position
						
						result.atlas_position = Vector2i(atlas_pos.x, atlas_pos.y)
						
						return result
	
	return null

func update_sprites():
	for i in range(3):
		for j in range(3):
			var slotId = 3 * i + j
			var slotContent = content[str(i)][str(j)]
			var sprite = find_child("Slot" + str(slotId) + "Sprite")
			
			if slotContent == null:
				sprite.region_rect.position = Vector2(-16, -16)
			else:
				var atlas_position = slotContent.atlas_position
				sprite.region_rect.position = Vector2(16 * atlas_position.x, 16 * atlas_position.y)

func clear_grid():
	for i in range(3):
		for j in range(3):
			content[str(i)][str(j)] = null
	
	update_sprites()

func craft():
	var result = get_result()
	
	if result:
		clear_grid()
		content["1"]["1"] = result
	
	update_sprites()

func _ready() -> void:
	clear_grid()
	load_recipes()

func crafting_interact():
	var slot_x = str(focused_slot.x)
	var slot_y = str(focused_slot.y)
	
	var held_item = occupant_object.get_held_item()
	
	occupant_object.set_held_item(content[slot_y][slot_x])
	content[slot_y][slot_x] = held_item
	
	update_sprites()
	
	occupant_object.set_can_act(true)
	
	occupied = false
	occupant = ""
	occupant_object = null

func _process(delta: float) -> void:
	if occupied:
		if occupant == "fire":
			if Input.is_action_just_pressed("fire_move_up"):
				focused_slot.y = clamp(focused_slot.y - 1, 0, 2)
			if Input.is_action_just_pressed("fire_move_down"):
				focused_slot.y = clamp(focused_slot.y + 1, 0, 2)
			if Input.is_action_just_pressed("fire_move_left"):
				focused_slot.x = clamp(focused_slot.x - 1, 0, 2)
			if Input.is_action_just_pressed("fire_move_right"):
				focused_slot.x = clamp(focused_slot.x + 1, 0, 2)
			if Input.is_action_just_pressed("fire_interact") and interact_counter >= interact_delay:
				crafting_interact()
		elif occupant == "water":
			if Input.is_action_just_pressed("water_move_up"):
				focused_slot.y = clamp(focused_slot.y - 1, 0, 2)
			if Input.is_action_just_pressed("water_move_down"):
				focused_slot.y = clamp(focused_slot.y + 1, 0, 2)
			if Input.is_action_just_pressed("water_move_left"):
				focused_slot.x = clamp(focused_slot.x - 1, 0, 2)
			if Input.is_action_just_pressed("water_move_right"):
				focused_slot.x = clamp(focused_slot.x + 1, 0, 2)
			if Input.is_action_just_pressed("water_interact") and interact_counter >= interact_delay:
				crafting_interact()
		$SlotSelector.visible = true
		$SlotSelector.position = Vector2(0, -5) + Vector2(focused_slot.x * 4, focused_slot.y * 3)
		
		interact_counter += 1
		
	else:
		$SlotSelector.visible = false
	

func interact(character):
	var held_item = character.get_held_item()
	
	if held_item and held_item.id == "hammer":
		craft()
	elif not occupied:
		focused_slot = Vector2i(0, 0)
		
		occupied = true
		occupant = character.character
		occupant_object = character
		
		interact_counter = 0
		
		character.set_can_act(false)
