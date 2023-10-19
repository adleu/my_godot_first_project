extends Node

var config = ConfigFile.new()

const FILE_PATH = "res://save.ini"

var levels 
var special_levels

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

func _default_special_levels():
	var default_levels = {
	0:{
	},
	1: {
		"name" : "comming soon",
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
		special_levels = _default_special_levels()
		_save()
		return
		
	levels = config.get_value("levels_data", "levels")
	special_levels = config.get_value("levels_data", "special_levels")

func _save():
	config.set_value("levels_data", "levels", levels)
	config.set_value("levels_data", "special_levels", special_levels)
	config.save(FILE_PATH)

func get_level_name(level_id, lvl = levels):
	if lvl.has(level_id):
		return lvl[level_id]["name"]
	else:
		return "Level " + str(level_id)

func get_level_time(level_id, lvl = levels):
	if lvl.has(level_id) and lvl[level_id].has("time"):
		return lvl[level_id]["time"]
	else:
		return null
		
func set_level_time(level_id, time, lvl = levels):
	if lvl.has(level_id) and lvl[level_id].has("time"):
		if lvl[level_id]["time"] == -1 or lvl[level_id]["time"] > time:
			lvl[level_id]["time"] = time
			_save()
		
func get_level_objectives(level_id, lvl = levels):
	if lvl.has(level_id) and lvl[level_id].has("objectives"):
		return lvl[level_id]["objectives"]
	else:
		return null
		
func level_objective_done(level_id, objective_name, lvl = levels):
	if lvl.has(level_id):
		if lvl[level_id].has("objectives") and lvl[level_id]["objectives"].has(objective_name):
			lvl[level_id]["objectives"][objective_name]["statut"] = true
			_save()
			
func is_objective_done(level_id, objective_name, lvl = levels):
	if lvl.has(level_id):
		if lvl[level_id].has("objectives") and lvl[level_id]["objectives"].has(objective_name):
			return lvl[level_id]["objectives"][objective_name]["statut"]
			
func reset_levels():
	levels = _default_levels()
	special_levels = _default_special_levels()
	config.set_value("levels_data", "levels", levels)
	config.set_value("levels_data", "special_levels", special_levels)
	config.save(FILE_PATH)

	
func objectives_to_unlock_level(level_id, lvl = levels) -> Array:
	var required_objc = []
	
	if lvl != levels:
		return []
		
	match level_id:
		1:
			pass
		2: 
			required_objc.append([1,"completed"])
		_: 
			pass
			
	return required_objc


func is_level_unlocked(level_id, lvl = levels) -> bool:
	for obj in objectives_to_unlock_level(level_id, lvl):
		var required_level_id = obj[0]
		var required_objective_name = obj[1]

		if !is_objective_done(required_level_id, required_objective_name, lvl):
			return false

	return true
		
func add_level_objective(level_id, objective_name, objective_desc, lvl = levels):
	if lvl.has(level_id):  # Vérifie si le niveau existe
		if !lvl[level_id].has("objectives"):
			lvl[level_id]["objectives"] = {}  # Crée un dictionnaire d'objectifs s'il n'existe pas

		# Vérifie si l'objectif du même nom existe déjà
		if !lvl[level_id]["objectives"].has(objective_name):
			# Crée un dictionnaire pour l'objectif
			var objective = {
				"statut": false,
				"desc": objective_desc
			}
			
			lvl[level_id]["objectives"][objective_name] = objective
			
			_save()

func get_prefix(level_type):
	if level_type == levels:
		return ""
	if level_type == special_levels:
		return "special_"
	return ""
