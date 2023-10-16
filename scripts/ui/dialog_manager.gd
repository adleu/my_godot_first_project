extends Node

@onready var text_box_scene = preload("res://scenes/ui/text_box/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position : Vector2

var sfx : AudioStream

var is_dialog_active = false
var can_advance_line = false
var is_dialog_finished = false



# return true when dialog finished
func start_dialog(position : Vector2, lines: Array[String], speech_sfx: AudioStream = null) -> bool:
	if is_dialog_active:
		if ! can_advance_line:
			text_box.accelerate()
		else:
			_continue_dialog()
		return is_dialog_finished
		
	
	dialog_lines = lines
	text_box_position = position
	sfx = speech_sfx
	_show_text_box()
	
	is_dialog_active = true
	is_dialog_finished = false
	return is_dialog_finished
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
		
func _continue_dialog():
	if is_dialog_active and can_advance_line:
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			is_dialog_finished = true
			return 
	
		_show_text_box()

func kill_dialog():
	if is_instance_valid(text_box):
		text_box.queue_free()
	is_dialog_active = false
	current_line_index = 0
	is_dialog_finished = true
