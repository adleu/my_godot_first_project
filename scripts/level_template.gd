extends Node2D

@export var next_level: String
@export var lvl_id: int
@export var player_camera_zoom: float
@export var camera_bottom_limit = 1000000

@onready var pause_menu = $pause
@onready var follow_cam = $Camera2D

var paused = false

func run():
	$UI.toggle_run_icon()


# Called when the node enters the scene tree for the first time.
func _ready():
	$UI.set_level_label("Level " + str(lvl_id))
	
	follow_cam.limit_top = 0
	follow_cam.limit_bottom = camera_bottom_limit
	follow_cam.zoom = Vector2(player_camera_zoom, player_camera_zoom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		_on_pause_restart_level()

		
func _on_ending_level_body_entered(body):
	if not next_level is String:
		return
	StageManager.change_stage(next_level)
	
	
func _on_pause_restart_level():
	get_tree().reload_current_scene()
	
