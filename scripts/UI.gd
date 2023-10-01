extends CanvasLayer
@onready var run_icon = $Control2/MarginContainer/Control/VBoxContainer2/RunIcon
@onready var level_label = $Control2/MarginContainer/Control/VBoxContainer/LevelLabel
@onready var inventory = $Control2/MarginContainer/Control/inventory
@onready var animation_rearrange = $RearrangeItemsAnimation
@onready var bonus_panel = $BonusPanel
@onready var panel_slide_animation = $BonusPanelAnimation

const bonus_panel_y = 15
const bonus_panel_x = 281

func _ready():
	inventory.size.x = 48
	inventory.size.y = 16
	
	bonus_panel.position.y = bonus_panel_y
	bonus_panel.position.x = bonus_panel_x
	
	animation_rearrange.seek(animation_rearrange.current_animation_length, false)
	hide_panel()
	
	

	


func toggle_run_icon(): 
	run_icon.visible = ! run_icon.visible
	
func set_level_label(text):
	level_label.text = text
	
func add_item(texture : Texture2D):
	if inventory.get_children()[0].texture == null:
		await show_panel()
		
	for i in inventory.get_children():
		if i.texture == null:
			i.texture = texture
			return

func remove_item():
	var items = inventory.get_children()
	items[0].texture = null
	if items.size() > 1:
		var pos_x = inventory.position.x
		animation_rearrange.play("rearrange_items")
		await animation_rearrange.animation_finished
		inventory.position.x = pos_x
		
	if items[1].texture == null:
		hide_panel()
		return
		
	for i in range(1, items.size()):
		if items[i].texture != null:
			items[i-1].texture = items[i].texture
			items[i].texture = null
			
func show_panel():
	panel_slide_animation.play("slide_in")
	await panel_slide_animation.animation_finished

func hide_panel():
	panel_slide_animation.play_backwards("slide_in")
	
			
