extends CanvasLayer
@onready var run_icon = $Control2/MarginContainer/HBoxContainer/Control2/VBoxContainer/RunIcon
@onready var level_label = $Control2/MarginContainer/HBoxContainer/Control/VBoxContainer/LevelLabel

func toggle_run_icon(): 
	run_icon.visible = ! run_icon.visible
	
func set_level_label(text):
	level_label.text = text
	

