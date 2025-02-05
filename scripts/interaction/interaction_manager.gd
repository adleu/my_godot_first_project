extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = "[e] to "

var active_areas = []
var can_interact = true
var hide_label = false
var interacting = false


func register_area(area: InteractionsArea):
	active_areas.append(area)
	
func unregister_area(area: InteractionsArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(delta):
	if active_areas.size()>0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 40
		label.global_position.x += 40
		label.global_position.x -= label.size.x / 2
		if !hide_label:
			label.show()
		else:
			label.hide()
	else:
		label.hide()
		
func _sort_by_distance_to_player(area1, area2):
	player = get_tree().get_first_node_in_group("player")
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
	
func _change_label_visibility():
	hide_label = ! hide_label
	
func update_interact_state(turn_on):
	if !interacting and turn_on:
		_change_label_visibility()
		interacting = true
	elif !turn_on and interacting:
		_change_label_visibility()
		interacting = false
	
