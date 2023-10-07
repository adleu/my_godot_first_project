extends Node2D

@onready var ui = $UI


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if Global.lvl == 0:
		player.position.y = player.position.y -350
		
		Global.set_lvl(1)
	ui.set_level_label("Valley")
	
