extends Node

var vsync = false
var fullscreen = false
var volume = 0.5
var lvl = 0

var interface = false
var level_names = ["None","Level 1", "Level 2"]
var lvl_max = level_names.size() - 1

const SAVE_FILE = "res://param.cfg"
const BUS_NAME = "Master"


var data = {}
func _ready():
	load_data()
	_initialize_param()

func _initialize_param():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BUS_NAME), linear_to_db(volume))
	
func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	data = {
		"vsync" = vsync,
		"fullscreen" = fullscreen,
		"volume" = volume,
		"lvl" = lvl
	}
	file.store_var(data)
	file = null

func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		data = {
			"vsync" = false,
			"fullscreen" = false,
			"volume" = 0.5,
			"lvl" = 0
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	data = file.get_var()
	vsync = data.vsync
	fullscreen = data.fullscreen
	volume = data.volume
	lvl = data.lvl
	file = null
	
func get_vsync():
	return vsync

func get_fullscreen():
	return fullscreen
	
func get_volume():
	return volume
	
func set_vsync(value : bool):
	vsync = value

func set_fullscreen(value : bool):
	fullscreen = value
	
func set_volume(value : float):
	volume = value

func set_config(_fullscreen, _vsync, _volume):
	fullscreen = _fullscreen
	vsync = _vsync
	volume = _volume
	save_data()
	
func set_lvl(_lvl):
	if _lvl <= lvl_max:
		lvl = _lvl
		save_data()
	
var running = false
func change_run_state():
	running = ! running
	
