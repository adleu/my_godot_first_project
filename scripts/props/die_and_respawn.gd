extends Node2D

@onready var resp = $AreaRespPoint
@onready var dead = $AreaDeadPoint
@onready var raycast = $RayCast2D


var save_pos = null

func _ready():
	resp.body_entered.connect(_resp_body_entered)
	dead.body_entered.connect(_dead_body_entered)
	
	for node in get_children():
		if node is CollisionShape2D:
			if "r_" in node.get_name() :
				remove_child(node)
				resp.add_child(node)
			elif "d_" in node.get_name():
				remove_child(node)
				dead.add_child(node)
				
func _resp_body_entered(body):
	if body.name == "Player":
		raycast.position = Vector2(body.position.x, body.position.y)
		raycast.force_raycast_update()
		
		while ! raycast.is_colliding():
			raycast.position.y += 1
			raycast.force_raycast_update()
			
		save_pos = raycast.position
		resp.get_children()[0].queue_free()
	
func _dead_body_entered(body):
	if save_pos != null:
		body.velocity.y = 0
		body.position = save_pos
		
