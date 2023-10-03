extends GPUParticles2D

func emit_particules():
	emitting = true
	$Timer.start(2)
	
	


func _on_timer_timeout():
	queue_free()
