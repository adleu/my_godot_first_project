extends Area2D

#disable lifeguard when the player enter
func _on_body_entered(body):
	for node in get_tree().get_nodes_in_group("lifeguard"):
		node.disable()
