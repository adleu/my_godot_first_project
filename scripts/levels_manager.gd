extends Node

var config = ConfigFile.new()

const FILE_PATH = "res://save.ini"

var levels 

func _default_levels():
	var default_levels = {
	0:{
		"name" : "Foothills Guide",
		"objectives": {
			"completed": {
				"statut" : false,
				"desc" : "Complete the Level"
			},	
		}
	},
	1: {
		"name" : "Sunset Peaks",
		"time": -1,
		"objectives": {
			"completed": {
				"statut" : false,
				"desc" : "Complete the Level"
			},	
		}
	},
	2: {
		"name" : "Serenity Summit",
		"time": -1,
		"objectives": {
			"completed": {
				"statut" : false,
				"desc" : "Complete the Level"
			},	
		}
	}
}
	return default_levels

func _ready():
	_load()


func _load():
	if config.load(FILE_PATH) != OK:
		levels = _default_levels()
		_save()
		return
		
	levels = config.get_value("levels_data", "levels")

func _save():
	config.set_value("levels_data", "levels", levels)
	config.save(FILE_PATH)

func get_level_name(level_id):
	if levels.has(level_id):
		return levels[level_id]["name"]
	else:
		return "Level " + str(level_id)

func get_level_time(level_id):
	if levels.has(level_id) and levels[level_id].has("time"):
		return levels[level_id]["time"]
	else:
		return null
		
func set_level_time(level_id, time):
	if levels.has(level_id) and levels[level_id].has("time"):
		if levels[level_id]["time"] == -1 or levels[level_id]["time"] > time:
			levels[level_id]["time"] = time
			_save()
		
func get_level_objectives(level_id):
	if levels.has(level_id):
		return levels[level_id]["objectives"]
	else:
		return null
		
func level_objective_done(level_id, objective_name):
	if levels.has(level_id):
		if levels[level_id].has("objectives") and levels[level_id]["objectives"].has(objective_name):
			levels[level_id]["objectives"][objective_name]["statut"] = true
			_save()
			
func is_objective_done(level_id, objective_name):
	if levels.has(level_id):
		if levels[level_id].has("objectives") and levels[level_id]["objectives"].has(objective_name):
			return levels[level_id]["objectives"][objective_name]["statut"]
			
func reset_levels():
	levels = _default_levels()
	config.set_value("levels_data", "levels", levels)
	config.save(FILE_PATH)

	
func objectives_to_unlock_level(level_id) -> Array:
	var required_objc = []
	match level_id:
		1:
			pass
		2: 
			required_objc.append([1,"completed"])
		_: 
			pass
			
	return required_objc


func is_level_unlocked(level_id) -> bool:
	for obj in objectives_to_unlock_level(level_id):
		var required_level_id = obj[0]
		var required_objective_name = obj[1]

		if !is_objective_done(required_level_id, required_objective_name):
			return false

	return true
		
#	for obj in objectives_to_unlock_level(level_id):
#		if ! obj["statut"] :
#			return false
#	return true
