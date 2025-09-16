extends Node2D

@onready var fireViewport = $CanvasLayer/FireViewportContainer/FireViewport
@onready var waterViewport = $CanvasLayer/WaterViewportContainer/WaterViewport

func _ready():
	fireViewport.world_2d = waterViewport.world_2d
