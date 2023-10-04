extends Node2D

func _ready():
	var trees = get_children()
	$tree01.visible = false
	
	var random_index = randi_range(0, trees.size() - 1)
	trees[random_index].visible = true
	
