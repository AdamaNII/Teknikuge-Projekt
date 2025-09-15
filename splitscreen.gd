extends Node2D

@onready var viewport1 = $CanvasLayer/SubViewportContainer/SubViewport
@onready var viewport2 = $CanvasLayer/SubViewportContainer2/SubViewport
@onready var camera1 = $CanvasLayer/SubViewportContainer/SubViewport/Camera2D
@onready var camera2 = $CanvasLayer/SubViewportContainer2/SubViewport/Camera2D
@onready var world = $CanvasLayer/SubViewportContainer/SubViewport/World

func _ready():
	viewport2.world_2d = viewport1.world_2d
