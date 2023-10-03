extends Sprite2D

func _on_area_2d_body_entered(body):
	if ! $OrbAnimation/OrbMovement.is_playing():
		$OrbAnimation/OrbMovement.play("guid_orb_movement")


func _on_orb_movement_animation_finished(anim_name):
	$OrbAnimation/OrbMovement.seek(0, true)
