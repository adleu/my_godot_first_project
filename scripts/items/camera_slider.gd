extends Area2D

enum DIRECTION{
	LEFT = 0,
	RIGHT = 1,
	TOP = 2,
	BOTTOM = 3
	}
	
@onready var static_body = $StaticBody2D

@export var bidirectional = false
@export var direction = DIRECTION.RIGHT
@export var tween_speed = 0.5

signal cam_is_ready

var camera
var pos : Vector2
var tween
var cam_is_moving = false


func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	

func _on_body_entered(body):
	pos = body.position


func _on_body_exited(body):
	match direction:
		DIRECTION.RIGHT:
			if body.position.x > pos.x:
				_move_camera_right()
				if bidirectional:
					direction = DIRECTION.LEFT
				else:
					block_area()
		
		DIRECTION.LEFT:
			if body.position.x < pos.x:
				_move_camera_left()
				if bidirectional:
					direction = DIRECTION.RIGHT
				else:
					block_area()

func _move_camera_left():
	if cam_is_moving:
		await cam_is_ready
		
	cam_is_moving = true
	
	tween = get_tree().create_tween()
	tween.tween_property(camera, "position", Vector2(camera.position.x - get_window().size.x + 200, camera.position.y), tween_speed)
	tween.tween_callback(camera_is_not_moving)


func _move_camera_right():
	if cam_is_moving:
		await cam_is_ready

	cam_is_moving = true
	
	tween = get_tree().create_tween()
	tween.tween_property(camera, "position", Vector2(camera.position.x + get_window().size.x - 200, camera.position.y), tween_speed)
	tween.tween_callback(camera_is_not_moving)

func camera_is_not_moving():
	cam_is_moving = false
	cam_is_ready.emit()
	
func block_area():
	for node in get_children():
		if node is CollisionShape2D:
			var new_col = CollisionShape2D.new()
			new_col.shape = node.shape
			new_col.global_position = node.position
			new_col.scale = Vector2(3,3)
			
			get_node(static_body.get_path()).add_child(new_col)
