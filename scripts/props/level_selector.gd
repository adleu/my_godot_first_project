extends Node2D

@onready var interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_open_level_menu")

func _open_level_menu():
	pass
