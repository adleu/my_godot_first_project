extends Sprite2D

func _on_area_2d_body_entered(body):
	queue_free()
