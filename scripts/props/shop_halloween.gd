extends Node2D

@onready var interaction_area = $InteractionArea
@onready var vendor = $Vendor
@onready var speech_sound = preload("res://ressources/assets/audio/effect/speech_sound/Dialog voice 4.wav")

const utils_dialog = preload("res://scripts/utils/dialog_utils.gd")

const DIALOG_PATH = "res://ressources/dialog/pumpkin_vendor.json"
var json_dialog = preload(DIALOG_PATH)

enum STATE{
	first_objective_not_completed = 0,
	first_objective_not_completed_and_talked = 1,
	first_objective_completed = 2,
	second_objective_not_completed = 3,
	second_objective_completed = 4,
	third_objective_not_completed = 5,
	third_objective_completed = 6,
}

var talked = false
var dialog : Array[String]
var dialog_data 

func _ready():
	interaction_area.interact = Callable(self, "_interact")
	dialog_data = utils_dialog._load_dialogue(DIALOG_PATH)

func _interact():
	handle_state(get_state())

func get_state():
	if ! LevelsManager.is_objective_done(2,"completed") and not talked:
		return STATE.first_objective_not_completed
	elif ! LevelsManager.is_objective_done(2,"completed") and talked:
		return STATE.first_objective_not_completed_and_talked
	elif LevelsManager.is_objective_done(1,"completed") and ! LevelsManager.levels[1]["objectives"].has("pumpkin_special"):
		return STATE.first_objective_completed
	elif LevelsManager.levels[1]["objectives"].has("pumpkin_special") and ! LevelsManager.is_objective_done(1,"pumpkin_special"):
		return STATE.second_objective_not_completed
	elif LevelsManager.levels[1]["objectives"].has("pumpkin_special") and LevelsManager.is_objective_done(1,"pumpkin_special"):
		#second objective done
		if ! LevelsManager.levels[2]["objectives"].has("pumpkin_special"):
			return STATE.second_objective_completed
		elif LevelsManager.levels[2]["objectives"].has("pumpkin_special") and ! LevelsManager.is_objective_done(2,"pumpkin_special"):
			return STATE.third_objective_not_completed
		elif LevelsManager.levels[2]["objectives"].has("pumpkin_special") and LevelsManager.is_objective_done(2,"pumpkin_special"):
			return STATE.third_objective_completed
	return null
		
func handle_state(state):
	match state:
		0:
			dialog = utils_dialog.get_lines(state, dialog_data)
			if _tell():
				talked = true
		1:
			dialog = utils_dialog.get_lines(state, dialog_data)
			_tell()
		2:
			dialog = utils_dialog.get_lines(state, dialog_data)
			if _tell():
				LevelsManager.add_level_objective(1, "pumpkin_special", "Find all the pumpkins")
		3:
			dialog = utils_dialog.get_lines(state, dialog_data)
			_tell()
		4:
			dialog = utils_dialog.get_lines(state, dialog_data)
			if _tell():
				LevelsManager.add_level_objective(2, "pumpkin_special", "Find all the pumpkins")
		5:
			dialog = utils_dialog.get_lines(state, dialog_data)
			_tell()
		6:
			dialog = utils_dialog.get_lines(state, dialog_data)
			_tell()
		_:
			pass

func _tell():
	InteractionManager.update_interact_state(true)
	var dialog_finished = DialogManager.start_dialog(vendor.global_position, dialog, speech_sound)
	if dialog_finished :
		InteractionManager.update_interact_state(false)
	return dialog_finished

func _get_random_lines(lines_tab):
	return lines_tab[randi() % lines_tab.size()]
