extends Node2D

func _process(delta: float) -> void:
	var world = get_parent().find_child("FireViewportContainer").find_child("FireViewport").find_child("World")
	
	$ContentLabel.text = str(world.get_diamond_collected()) + " / " + str(world.get_diamond_max())
