extends CharacterBody2D

@export var character: String
@export var camera: Camera2D
@export var spritesheet: Texture

var speed = 48

func _enter_tree() -> void:
	$Sprite2D.texture = spritesheet

func _physics_process(delta: float) -> void:
	
	if character == "fire":
		velocity = Input.get_vector("fire_move_left", "fire_move_right", "fire_move_up", "fire_move_down") * speed
	elif character == "water":
		velocity = Input.get_vector("water_move_left", "water_move_right", "water_move_up", "water_move_down") * speed
	
	move_and_slide()

func _process(delta: float) -> void:
	camera.position = position
	z_index = position.y
