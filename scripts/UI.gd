extends CanvasLayer
@onready var run_icon = $Control2/MarginContainer/Control/VBoxContainer2/RunIcon
@onready var level_label = $Control2/MarginContainer/Control/VBoxContainer/LevelLabel
@onready var inventory = $Control2/MarginContainer/Control/inventory
@onready var animation_rearrange = $RearrangeItemsAnimation

func _ready():
#	animation_rearrange.current_animation = "rearrange_items"
	inventory.size.x = 48
	inventory.size.y = 16
	animation_rearrange.seek(animation_rearrange.current_animation_length, false)
	

func toggle_run_icon(): 
	run_icon.visible = ! run_icon.visible
	
func set_level_label(text):
	level_label.text = text
	
func add_item(texture : Texture2D):
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
		
	for i in range(1, items.size()):
		if items[i].texture != null:
			items[i-1].texture = items[i].texture
			items[i].texture = null
	
			
