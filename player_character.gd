extends CharacterBody2D

@export var character: String
@export var camera: Camera2D
@export var spritesheet: Texture

@onready var world = get_parent()

var sprite: Sprite2D

var speed = 48
var facing = "down"

var target_tile: Vector2i

var held_item

func _enter_tree() -> void:
	sprite = $Sprite2D
	sprite.texture = spritesheet

func _physics_process(delta: float) -> void:
	
	if character == "fire":
		velocity = Input.get_vector("fire_move_left", "fire_move_right", "fire_move_up", "fire_move_down") * speed
	elif character == "water":
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
		var atlas_position = item.AtlasPosition
		$HeldItem.region_rect.position = Vector2(16 * atlas_position.x, 16 * atlas_position.y)
	else:
		$HeldItem.region_rect.position = Vector2(-16, -16)

func interact():
	
	if target_tile.x < 0 or target_tile.y < 0:
		return
	
	var interactible = world.get_interactible(target_tile)
	
	if held_item:
		if !interactible and world.can_place_interactible(target_tile):
			world.set_interactible(target_tile, held_item.AtlasPosition, held_item.Name, held_item.Id)
			set_held_item(null)
	else:
		if interactible:
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
		if Input.is_action_just_pressed("fire_interact"):
			interact()
	elif character == "water":
		if Input.is_action_just_pressed("water_interact"):
			interact()
