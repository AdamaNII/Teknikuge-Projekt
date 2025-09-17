extends CharacterBody2D

@export var character: String
@export var camera: Camera2D
@export var spritesheet: Texture

@onready var world = get_parent()

var sprite: Sprite2D

var speed = 48
var facing = "down"
var can_act = true

var target_tile: Vector2i

var held_item

var in_world_recipes = [
	{
		object_0 = "stick",
		object_1 = "stick",
		result = {
			atlas_position = Vector2i(0, 2),
			name = "Crafting Table",
			id = "crafting_table", 
			special = {
				can_pickup = false,
				interactible_object = "res://scenes/crafting_table.tscn",
				extra_tiles_foreground = [
					[Vector2i(0, -1), Vector2i(0, 1)]
				]
			}
		}
	},
	{
		object_0 = "stick",
		object_1 = "stone",
		result = {
			atlas_position = Vector2i(3, 0),
			name = "Hammer",
			id = "hammer"
		}
	}
]

func _enter_tree() -> void:
	sprite = $Sprite2D
	sprite.texture = spritesheet

func _physics_process(delta: float) -> void:
	
	if character == "fire" and can_act:
		velocity = Input.get_vector("fire_move_left", "fire_move_right", "fire_move_up", "fire_move_down") * speed
	elif character == "water" and can_act:
		velocity = Input.get_vector("water_move_left", "water_move_right", "water_move_up", "water_move_down") * speed
	
	if velocity.y < 0:
		sprite.region_rect.position.y = 64
		facing = "up"
	elif velocity.y > 0:
		sprite.region_rect.position.y = 0
		facing = "down"
	if velocity.x < 0:
		sprite.region_rect.position.y = 32
		facing = "left"
	elif velocity.x > 0:
		sprite.region_rect.position.y = 96
		facing = "right"
	
	move_and_slide()

func set_held_item(item = null):
	held_item = item
	
	if item:
		var atlas_position = item.atlas_position
		$HeldItem.region_rect.position = Vector2(16 * atlas_position.x, 16 * atlas_position.y)
	else:
		$HeldItem.region_rect.position = Vector2(-16, -16)
		
func get_held_item():
	return held_item

func set_can_act(enabled: bool) -> void:
	can_act = enabled

func interact():
	
	if target_tile.x < 0 or target_tile.y < 0:
		return
	
	var interactible = world.get_interactible(target_tile)
	
	if interactible and interactible.has("interactible_object"):
		interactible.interactible_object.interact(self)
	elif held_item:
		if !interactible and world.can_place_interactible(target_tile):
			world.set_interactible(target_tile, held_item.atlas_position, held_item.name, held_item.id)
			set_held_item(null)
		elif interactible:
			
			for recipe in in_world_recipes:
				
				if (held_item.id == recipe.object_0 and interactible.id == recipe.object_1) or (held_item.id == recipe.object_1 and interactible.id == recipe.object_0):
					var result = recipe.result
					
					set_held_item(null)
					world.clear_interactible(target_tile)
					
					if result.has("special"):
						world.set_interactible(target_tile, result.atlas_position, result.name, result.id, result.special)
					else:
						world.set_interactible(target_tile, result.atlas_position, result.name, result.id)
					return
	else:
		if interactible and interactible.can_pickup == true:
			set_held_item(interactible)
			world.clear_interactible(target_tile)

func _process(delta: float) -> void:
	camera.position = position
	
	target_tile = Vector2(round((position.x - 8)/16), round((position.y)/16))
	match facing:
		"up":
			target_tile.y -= 1
		"down":
			target_tile.y += 1
		"left":
			target_tile.x -= 1
		"right":
			target_tile.x += 1
			
	if facing == "up":
		$HeldItem.visible = false
	else:
		$HeldItem.visible = true
	
	$TargetMarker.global_position = target_tile * 16 + Vector2i(8, 8)
	
	if character == "fire":
		if Input.is_action_just_pressed("fire_interact") and can_act:
			interact()
	elif character == "water":
		if Input.is_action_just_pressed("water_interact") and can_act:
			interact()
