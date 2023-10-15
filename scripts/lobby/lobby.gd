extends Node2D

@onready var ui = $UI


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if ! LevelsManager.is_objective_done(1,"completed"):
		player.position.y = player.position.y -350
		Global.set_lvl(1)
	else:
		var spawn = preload("res://scenes/entities/items/animations/portal_spawn.tscn")
		var spawn_instance = spawn.instantiate()
		add_child(spawn_instance)
		spawn_instance.position = Vector2(0,250)
		
	ui.set_level_label("Valley")
	
	
