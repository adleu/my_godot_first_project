extends Node2D

@onready var interaction_area = $InteractionArea
@onready var interface = $CanvasLayer
@onready var dest = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/Label2

@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	interaction_area.interact = Callable(self, "_open_level_menu")

func _open_level_menu():
	interface.show()
	player.set_physics_process(false)


func _on_button_pressed():
	interface.hide()
	player.set_physics_process(true)


func _on_left_pressed():
	pass # Replace with function body.


func _on_right_pressed():
	pass # Replace with function body.
