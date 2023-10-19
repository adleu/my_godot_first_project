extends CanvasLayer

func _ready():
	get_node("ColorRect").hide()
	self.visible = false
	$ColorRect/Label.hide()

func change_stage(stage_path):
	get_tree().paused = true
	self.visible = true
	
	get_node("ColorRect").show()
	
	$Animation.play("trans_in")
	await get_node("Animation").animation_finished
	
	$ColorRect/Label.show()
	get_tree().change_scene_to_file(stage_path)
	$ColorRect/Label.hide()
	
	$Animation.play("trans_out")
	get_tree().paused = false
	
	await get_node("Animation").animation_finished
	get_node("ColorRect").hide()
	self.hide()
