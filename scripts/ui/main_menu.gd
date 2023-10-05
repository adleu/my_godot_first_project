extends Control

@export var new_game_scene : PackedScene

@onready var hover_audio = $HoverButtonAudio
@onready var main_theme_audio = $MainThemeAudio
@onready var option_menu = $MenuOption
@onready var load_button = $MainButtonContainer/VBoxContainer/LoadButton
@onready var credits = $Credits

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.running = false
	load_button.disabled = Global.lvl == 0
	
	for bouton in get_tree().get_nodes_in_group("menu_button"):
		if !bouton.disabled:
			_connect_signal(bouton)
	main_theme_audio.play()


func _mouse_entered():
	hover_audio.play()


func _connect_signal(button : Button):
	button.connect("mouse_entered", _mouse_entered)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_new_game_button_pressed():
	if new_game_scene is PackedScene:
		#get_tree().change_scene_to_packed(new_game_scene)
		StageManager.change_stage("res://scenes/levels/level_0.tscn")
		
func _on_main_theme_audio_finished():
	main_theme_audio.play()

func _on_options_button_pressed():
	option_menu._set_visible()
	
func _on_load_button_pressed():
	var level = "res://scenes/levels/level_" + str(Global.lvl) +".tscn"
	StageManager.change_stage(level)


func _on_back_button_pressed():
	credits.hide()


func _on_credits_button_pressed():
	credits.show()
