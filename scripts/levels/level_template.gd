extends Node2D

@export var next_level: String
@export var lvl_id: int



@export var player_camera_zoom: float
@export var camera_bottom_limit = 1000000
@export var camera_top_limit = 0
@export var level_type_string = "levels"

@export var respawning_orb = false

@onready var pause_menu = $pause
@onready var follow_cam = $Camera2D
var jump_bonus_scene = preload("res://scenes/entities/items/bonus_jump_orb.tscn")
var glide_bonus_scene = preload("res://scenes/entities/items/bonus_glider_orb.tscn")
const utils_level_name_preload = preload("res://scripts/utils/level_name_mapping.gd")


var level_type

var level_time = 0.0
var start_level_msec = 0.0


var paused = false
var orb_and_pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	level_type = utils_level_name_preload.new().get_level_from_string(level_type_string)
	if respawning_orb:
		for node in get_tree().get_nodes_in_group("bonus_orb"):
			node.visibility_changed.connect(_bonus_taken.bind(node))
		get_tree().get_first_node_in_group("player").ui_remove_bonus.connect(_bonus_used)
	
	$UI.set_level_label(LevelsManager.get_level_name(lvl_id, level_type))
	
#	follow_cam.limit_top = camera_top_limit
#	follow_cam.limit_bottom = camera_bottom_limit
#	follow_cam.zoom = Vector2(player_camera_zoom, player_camera_zoom)
	
	start_level_msec = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		_on_pause_restart_level()
	if Input.is_action_just_pressed("finish_level"):
		_on_ending_level_body_entered(null)

		
func _on_ending_level_body_entered(body):
	if not LevelsManager.is_objective_done(lvl_id, "completed"):
		LevelsManager.level_objective_done(lvl_id, "completed")
	LevelsManager.set_level_time(lvl_id, (Time.get_ticks_msec() - start_level_msec) / 1000.0)
	
	var nodes = get_tree().get_nodes_in_group("before_ending_level")
	for node in nodes:
		if node.has_method("before_ending_level"):
			var node_data = node.call("before_ending_level")
		
	
	if not next_level is String:
		return
		
	StageManager.change_stage(next_level)
	
	
func _on_pause_restart_level():
	get_tree().reload_current_scene()
	
func _bonus_taken(node):
	orb_and_pos.append([node.get_type(), node.position])

func _bonus_used():
	var bonus = orb_and_pos.pop_front()
	var new_bonus
	match bonus[0]:
		1 : 
			new_bonus = jump_bonus_scene.instantiate()
		2 :
			new_bonus = glide_bonus_scene.instantiate()
	
	
	await get_tree().create_timer(2.0).timeout
	add_child(new_bonus)
	new_bonus.position = bonus[1]
	new_bonus.visibility_changed.connect(_bonus_taken.bind(new_bonus))
