extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_area_2d_body_entered(body):
	if ! $OrbAnimation/OrbMovement.is_playing():
		$OrbAnimation/OrbMovement.play("guid_orb_movement")


func _on_orb_movement_animation_finished(anim_name):
	$OrbAnimation/OrbMovement.seek(0, true)
