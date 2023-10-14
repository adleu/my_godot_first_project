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

@onready var player = get_tree().get_first_node_in_group("player")

var level_names = Global.level_names
var current_selection = 0
var last_selection = current_selection
var ongoing_animation = false

func _ready():
	interface.hide()
	interaction_area.interact = Callable(self, "_open_level_menu")
	portal_animation.play("disapear")
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if interface.visible:
			_on_cancel_pressed()
			
func _open_level_menu():
	if ongoing_animation:
		audio_machine.play()
		return
	interface.show()
	Global.interface = true
	player.set_physics_process(false)

func _on_left_pressed():
	if current_selection > 0:
		current_selection -= 1
		_update_label()

func _on_right_pressed():
	if current_selection < LevelsManager.levels.size() - 1: # -1 for level 0
		current_selection += 1
		_update_label()
		
func _update_label():
	if current_selection == 0:
		dest.text = "None"
		dest.modulate = Color(1, 1, 1)
	else :
		dest.text = LevelsManager.get_level_name(current_selection)
		if LevelsManager.is_level_unlocked(current_selection):
			dest.modulate = Color(1, 1, 1)
		else :
			dest.modulate = Color(1, 1, 1, 0.337)


func _on_area_2d_body_entered(body):
	if current_selection != 0:
		var level = "res://scenes/levels/level_" + str(current_selection) +".tscn"
		StageManager.change_stage(level)


func _on_ok_pressed():
	if ! LevelsManager.is_level_unlocked(current_selection):
		audio_machine.play()
		return
		
	interface.hide()
	Global.interface = false
	
	player.set_physics_process(true)
	
	
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
	current_selection = last_selection
	_update_label()
