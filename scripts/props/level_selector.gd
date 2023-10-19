extends Node2D
class_name  LevelSelector

@onready var interaction_area = $InteractionArea
@onready var interface = $CanvasLayer
@onready var dest = $CanvasLayer/MarginContainer/VBoxContainer2/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/Label
@onready var portal_animation = $Area2D/AnimationPlayer
@onready var portal_col = $Area2D/CollisionShape2D
@onready var light = $PointLight2D
@onready var machine_door_animation = $machine/machine_door/AnimationMachineDoor
@onready var audio_machine = $machine/AudioMachine
@onready var audio_machine_on = $machine/AudioMachineOn
@onready var audio_machine_scroll = $machine/AudioMachineScroll
@onready var level_info_panel  = $CanvasLayer/LevelInfoPanel
@onready var player = get_tree().get_first_node_in_group("player")

var level_name_mapping := {
	"levels": LevelsManager.levels,
	"special" : LevelsManager.special_levels
}

@export var level_type_export_string : String = "levels"
var level_type

var current_selection = 0
var last_selection = current_selection
var ongoing_animation = false

var all_level_panel = []



func _ready():
	level_type = level_name_mapping[level_type_export_string]
	interface.hide()
	portal_col.disabled = true
	interaction_area.interact = Callable(self, "_open_level_menu")
	for lvl in level_type:
		if lvl != 0:
			all_level_panel.append(level_info_panel.duplicate())
			interface.add_child(all_level_panel[lvl-1])
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if interface.visible:
			_on_cancel_pressed()
			
func _open_level_menu():
	
	_update_panel_content()
			
	if ongoing_animation:
		audio_machine.play()
		return
	interface.show()
	Global.interface = true
	player.set_physics_process(false)

func _on_left_pressed():
	if current_selection > 0:
		audio_machine_scroll.play()
		current_selection -= 1
		_update_label()
		if current_selection == 0:
			_update_level_panel(0)
		else:
			_update_level_panel(-1)

func _on_right_pressed():
	if current_selection < level_type.size() - 1: # -1 for level 0
		audio_machine_scroll.play()
		current_selection += 1
		_update_label()
		_update_level_panel(1)
		
func _update_label():
	if current_selection == 0:
		dest.text = "None"
		dest.modulate = Color(1, 1, 1)
	else :
		dest.text = LevelsManager.get_level_name(current_selection, level_type)
		if LevelsManager.is_level_unlocked(current_selection, level_type):
			dest.modulate = Color(1, 1, 1)
		else :
			dest.modulate = Color(1, 1, 1, 0.337)

func _on_area_2d_body_entered(body):
	if current_selection != 0:
		
		var level = "res://scenes/levels/" + LevelsManager.get_prefix(level_type)+ "level_" + str(current_selection) +".tscn"
		StageManager.change_stage(level)

func _on_ok_pressed():
	if ! LevelsManager.is_level_unlocked(current_selection, level_type):
		audio_machine.play()
		return
		
	interface.hide()
	Global.interface = false
	
	player.set_physics_process(true)
	
	audio_machine_on.play()
	if last_selection == 0 and current_selection != 0:
		ongoing_animation = true
		machine_door_animation.play_backwards("close")
		await machine_door_animation.animation_finished
		portal_animation.play("emerge")
		light.enabled = true
		portal_col.disabled = true
		
		await portal_animation.animation_finished
		portal_animation.play("idle")
		portal_col.disabled = false	
		ongoing_animation = false
		
	elif last_selection != 0 and current_selection == 0:
		ongoing_animation = true
		portal_animation.play("disapear")
		portal_col.disabled = true
		light.enabled = false
		machine_door_animation.play("close")
		await portal_animation.animation_finished
		ongoing_animation = false
		
	last_selection = current_selection

func _on_cancel_pressed():
	interface.hide()
	player.set_physics_process(true)
	Global.interface = false
	
	while current_selection != last_selection:
		if current_selection < last_selection:
			current_selection += 1
			_update_level_panel(1)
		if current_selection > last_selection:
			current_selection -= 1
			if current_selection == 0:
				_update_level_panel(0)
			else:
				_update_level_panel(-1)
				
	_update_label()
	
func _update_panel_content():
	for lvl in level_type:
		if lvl != 0:
			all_level_panel[lvl-1].set_content(generate_level_info(lvl))
			
func _update_level_panel(direction):
	if direction == 1:
		all_level_panel[current_selection-1].move_down()
		if current_selection > 1: 
			all_level_panel[current_selection-2].move_down()
	if direction == -1:
		all_level_panel[current_selection-1].move_up()
		all_level_panel[current_selection-2].move_up()
	if direction == 0:
		all_level_panel[current_selection].move_up()

func generate_level_info(lvl):
	var info = ""
	if LevelsManager.is_level_unlocked(lvl, level_type):
		var time = LevelsManager.get_level_time(lvl, level_type)
			
		if time != null and time != -1:
			var minutes = int(time / 60)
			var seconds = int(time) % 60
			var milliseconds = int((time - int(time)) * 100)
			var time_text = ""
			
			if minutes == 0:
				var rounded_seconds = int(seconds * 100) / 100  # Arrondir à deux décimales
				time_text = str(rounded_seconds) + " s " + str(milliseconds)
			else:
				var rounded_seconds = int(seconds * 100) / 100  # Arrondir à deux décimales
				time_text = str(minutes) + " m  " + str(rounded_seconds) + " s " + str(milliseconds)
			
			info += "[b]Time[/b]  "
			info += time_text
#			info += str(time) + " secondes"
			info += "\n \n"
		
		if level_type[lvl].has("objectives"):
			info += "[b]Challenges [/b]\n"
			for obj_name in LevelsManager.get_level_objectives(lvl, level_type):
				var obj_data = LevelsManager.get_level_objectives(lvl, level_type)[obj_name]
				if obj_data.has("statut") and obj_data["statut"] == true:
					info += "[font color ='grey'][OK]  [/font]"
				if obj_data.has("desc"):
					if obj_data["statut"] == true:
						info +="[font color ='grey']" + obj_data["desc"] + "[/font]"+ "\n"
					else:
						info += obj_data["desc"] + "\n"
	else:
		info += "[b]Required  :[/b]\n\n"
		var otu = LevelsManager.objectives_to_unlock_level(lvl, level_type)
		for objective in otu:
			var level_id = objective[0]
			var objective_name = objective[1]
			var level_name = LevelsManager.get_level_name(level_id, level_type)
			var objective_desc = LevelsManager.get_level_objectives(level_id, level_type)[objective_name]["desc"]
			info += level_name + " : " + objective_desc + "\n"
			
	return info
