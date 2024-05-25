extends Node2D

@onready var resp = $AreaRespPoint
@onready var dead = $AreaDeadPoint
@onready var raycast = $RayCast2D
@onready var color_rect = $CanvasLayer/ColorRect
@onready var canvas = $CanvasLayer

@export var one_shot = false


var save_pos = null
var tween

func _ready():
	canvas.hide()
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
		
		
		if one_shot:
			resp.get_children()[0].queue_free()
	
func _dead_body_entered(body):
	if save_pos != null:
		canvas.show()
		tween = get_tree().create_tween()
		tween.tween_property(color_rect, "modulate",Color(1, 1, 1) , 0.3)
		tween.tween_callback(_fade_out.bind(body))


func _fade_out(body):
	body.velocity.y = 0
	body.position = save_pos
	tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate",Color(1, 1, 1, 0) , 0.3)
	tween.tween_callback(canvas.hide)
	
	
