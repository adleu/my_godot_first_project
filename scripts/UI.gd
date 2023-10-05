extends CanvasLayer
@onready var run_icon = $Control2/MarginContainer/Control/VBoxContainer2/RunIcon
@onready var level_label = $Control2/MarginContainer/Control/VBoxContainer/LevelLabel
@onready var inventory = $Control2/MarginContainer/Control/inventory
@onready var animation_rearrange = $RearrangeItemsAnimation
@onready var bonus_panel = $Control2/VboxPanel
@onready var panel_slide_animation = $BonusPanelAnimation
@onready var label_description = $Control2/Descritpion/desc1

@onready var slot1 = $Control2/VboxPanel/BonusPanel/slots/slot1
@onready var slot2 = $Control2/VboxPanel/BonusPanel/slots/slot2
@onready var slot3 = $Control2/VboxPanel/BonusPanel/slots/slot3


const bonus_panel_y = -25
const bonus_panel_x = 296
var item_desription : Array

func _ready():
	inventory.size.x = 48
	inventory.size.y = 16
	
	inventory.position.x = 275
	inventory.position.y = 0
	
	bonus_panel.position.y = bonus_panel_y
	bonus_panel.position.x = bonus_panel_x
	
	if Global.running:
		run_icon.show()
	
	
	# animation_rearrange.seek(animation_rearrange.current_animation_length, false)
	#hide_panel()
	
	


func toggle_run_icon(): 
	run_icon.visible = ! run_icon.visible
	
func set_level_label(text):
	level_label.text = text
	
func add_item(item):
	var texture = item.get_texture()
	item_desription.append(item.get_descripion())
	
	if inventory.get_children()[0].texture == null:
		show_panel()
		
	for i in inventory.get_children():
		if i.texture == null:
			i.texture = texture
			return

func remove_item():
	
	var items = inventory.get_children()
	item_desription.pop_front()
	items[0].texture = null
	if items.size() > 1:
		var pos_x = inventory.position.x
		animation_rearrange.play("rearrange_items")
		await animation_rearrange.animation_finished
		inventory.position.x = pos_x
		
	if items[1].texture == null and items[0].texture == null:
		hide_panel()
		return
		
	for i in range(1, items.size()):
		if items[i].texture != null:
			items[i-1].texture = items[i].texture
			items[i].texture = null
			
func show_panel():
	panel_slide_animation.play("slide_in")
	inventory.get_children()[0].visible = false
	await panel_slide_animation.animation_finished
	inventory.get_children()[0].visible = true
	

func hide_panel():
	panel_slide_animation.play_backwards("slide_in")
	_on_mouse_exited_slot()
	
func _slot_mouse_enterded(slot_number):
	if slot_number < item_desription.size():
		label_description.text = item_desription[slot_number]
	

func _on_mouse_exited_slot():
	label_description.text = ""


func _on_slot_1_mouse_entered():
	_slot_mouse_enterded(0)


func _on_slot_2_mouse_entered():
	_slot_mouse_enterded(1)


func _on_slot_3_mouse_entered():
	_slot_mouse_enterded(2)

