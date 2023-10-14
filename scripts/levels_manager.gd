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
		"time": null,
		"objectives": {
			"completed": {
				"statut" : false,
				"desc" : "Complete the Level"
			},	
		}
	},
	2: {
		"name" : "Serenity Summit",
		"time": null,
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
	if levels.has(level_id):
		return levels[level_id]["time"]
	else:
		return null
		
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
	match level_id:
		1:
			return []
		2: 
			return [levels[1]["objectives"]["completed"]]
		_: 
			return []


func is_level_unlocked(level_id) -> bool:
	for obj in objectives_to_unlock_level(level_id):
		if ! obj["statut"] :
			return false
	return true
