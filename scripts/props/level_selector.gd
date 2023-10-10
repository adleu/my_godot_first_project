extends Node2D
class_name  LevelSelector

@onready var interaction_area = $InteractionArea
@onready var interface = $CanvasLayer
@onready var dest = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/Label2
@onready var portal_animation = $Area2D/AnimationPlayer
@onready var portal_col = $Area2D/CollisionShape2D
@onready var light = $PointLight2D

@onready var player = get_tree().get_first_node_in_group("player")

var level_names = Global.level_names
var current_selection = 0
var last_selection = current_selection

func _ready():
	interaction_area.interact = Callable(self, "_open_level_menu")
	portal_animation.play("disapear")
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if interface.visible:
			interface.hide()
			player.set_physics_process(true)
			Global.interface = false
			
func _open_level_menu():
	interface.show()
	Global.interface = true
	player.set_physics_process(false)

func _on_button_pressed():
	interface.hide()
	Global.interface = false
	player.set_physics_process(true)
	if last_selection == 0 and current_selection != 0:
		light.enabled = true
		portal_animation.play("emerge")
		portal_col.disabled = true
		await portal_animation.animation_finished
		portal_animation.play("idle")
		portal_col.disabled = false	
	elif last_selection != 0 and current_selection == 0:
		portal_animation.play("disapear")
		portal_col.disabled = true
		light.enabled = false
	last_selection = current_selection

func _on_left_pressed():
	if current_selection > 0:
		current_selection -= 1
		_update_label()

func _on_right_pressed():
	if current_selection < Global.lvl:
		current_selection += 1
		_update_label()
		
func _update_label():
	dest.text = level_names[current_selection]


func _on_area_2d_body_entered(body):
	if current_selection != 0:
		var level = "res://scenes/levels/level_" + str(current_selection) +".tscn"
		StageManager.change_stage(level)

		
