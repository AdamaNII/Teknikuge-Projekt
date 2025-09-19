extends Node2D

@onready var fire_viewport = $CanvasLayer/FireViewportContainer/FireViewport
@onready var water_viewport = $CanvasLayer/WaterViewportContainer/WaterViewport

@onready var game_over_screen = $CanvasLayer/GameOverScreen

@export var world: PackedScene

@onready var current_world = fire_viewport.find_child("World")

func _ready():
	fire_viewport.world_2d = water_viewport.world_2d

func restart():
	current_world.queue_free()
	
	var new_world = world.instantiate()
	new_world.name = "World"
	fire_viewport.add_child(new_world)
	current_world = new_world
	

func game_over():
	game_over_screen.visible = true


func _on_restart_button_pressed() -> void:
	game_over_screen.visible = false
	restart()
