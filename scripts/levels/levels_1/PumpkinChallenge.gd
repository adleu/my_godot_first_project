extends Node2D

var pumpkin_left = 0
var ui 
var processed = false

func _ready():
	
	ui = get_tree().get_first_node_in_group("ui")
	if ! LevelsManager.levels[get_parent().lvl_id]["objectives"].has("pumpkin_special") or LevelsManager.is_objective_done(get_parent().lvl_id,"pumpkin_special"):
		hide()
		print("dont have objective or done")
		queue_free()
	else :
		print("loading :" + "chal_0_level_" + str(get_parent().lvl_id))
		Saver.load_game("chal_0_level_" + str(get_parent().lvl_id))
		show()
			
func _process(delta):
	if processed:
		return
	processed = true
	for node in get_tree().get_nodes_in_group("pickable_pumpkin"):
		if node.visible:
			pumpkin_left += 1
			node.visibility_changed.connect(_pumpkin_taken)
			update_label()
			
func _pumpkin_taken():
	pumpkin_left -= 1
	update_label() 
	
func update_label():
	ui.edit_text_top_right("pumpkin left : " +str(pumpkin_left))
	
func before_ending_level():
	if pumpkin_left == 0:
		LevelsManager.level_objective_done(get_parent().lvl_id, "pumpkin_special") 
		Saver.delete_save_file("chal_0_level_" + str(get_parent().lvl_id))
	else :
		Saver.save_game("chal_0_level_" + str(get_parent().lvl_id))
	
