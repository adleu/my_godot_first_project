extends Node2D

@onready var interaction_area = $InteractionArea
@onready var speech_sound = preload("res://ressources/assets/audio/effect/speech_sound/Dialog voice 4.wav")

enum STATE{
	first_objective_not_completed = 0,
	first_objective_not_completed_and_talked = 1,
	first_objective_completed = 2,
	second_objective_not_completed = 3,
	second_objective_completed = 4,
	second_objective_completed_and_talked = 5,
}

var talked = false
var dialog 

const lines_first_objective_not_completed_1 : Array[String] = [
	"Heyy !",
	"You should complete Sunset Peaks once... loser.",
]

const lines_first_objective_not_completed_2 : Array[String] = [
	"Look for the interdimensional vending machine, do your job, then come back to me."
]

const all_lines_first_objective_not_completed = [
	lines_first_objective_not_completed_2,
	lines_first_objective_not_completed_1
]

func _ready():
	interaction_area.interact = Callable(self, "_interact")


func _interact():
	pass
	

func get_state():
	if ! LevelsManager.is_objective_done(1,"completed") and not talked:
		return STATE.first_objective_not_completed
	elif ! LevelsManager.is_objective_done(1,"completed") and talked:
		return STATE.first_objective_not_completed_and_talked
	elif LevelsManager.is_objective_done(1,"completed"):
		return STATE.first_objective_completed

func handle_state(state : STATE):
	match state:
		0:
			InteractionManager.update_interact_state(true)
			dialog = lines_first_objective_not_completed_1
			if DialogManager.start_dialog($Vendor.global_position, dialog, speech_sound):
				InteractionManager.update_interact_state(false)
				talked = true
		1:
			InteractionManager.update_interact_state(true)
			if DialogManager.start_dialog($Vendor.global_position, dialog, speech_sound):
				InteractionManager.update_interact_state(false)
