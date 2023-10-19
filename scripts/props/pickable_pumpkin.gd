extends Area2D
@onready var sound = $AudioStreamPlayer
@onready var col = $CollisionShape2D



func _on_body_entered(body):
	if !visible:
		return
	sound.play()
	hide()
	col.set_deferred("disabled", true)
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"visible" : visible,
		"z_index" : z_index
	}
	return save_dict
