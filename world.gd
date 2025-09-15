extends Node2D

@export var stickLocations: Array[Vector2i]
@export var rockLocations: Array[Vector2i]
@export var weedLocations: Array[Vector2i]

func getInteractible(coords: Vector2i):
	print("Get Interactible!")
