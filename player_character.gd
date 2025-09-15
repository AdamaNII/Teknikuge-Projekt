extends CharacterBody2D

@export var character: String
@export var camera: Camera2D
@export var spritesheet: Texture

var sprite: Sprite2D

var speed = 48
var facing = "down"

var targetTile: Vector2

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

func _process(delta: float) -> void:
	camera.position = position
	z_index = position.y
	
	targetTile = Vector2(round((position.x - 8)/16), round((position.y)/16))
	match facing:
		"up":
			targetTile.y -= 1
		"down":
			targetTile.y += 1
		"left":
			targetTile.x -= 1
		"right":
			targetTile.x += 1
	
	$TargetMarker.global_position = targetTile * 16 + Vector2(8, 8)
	
	if character == "fire":
		print(get_parent().find_child("BaseLayer").get_cell_atlas_coords(targetTile))
		get_parent().getInteractible(Vector2i(0, 0))
	
	
