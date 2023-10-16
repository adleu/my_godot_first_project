extends CanvasLayer

@onready var hover_audio = $HoverButtonAudio
@onready var restart_button = $OptionsMenu/MenuPanel/VBoxContainer/RestartButton

@export var restart_button_on = true
signal restart_level

# Called when the node enters the scene tree for the first time.
func _ready():
	restart_button.visible = restart_button_on
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Global.interface :
		if Input.is_action_just_pressed("escape") and ! $OptionsMenu/MenuPanel/MenuOption.visible:
			_pause_game()
	
func _on_resume_button_pressed():
	_pause_game()
	
func _pause_game():
	if !visible:
		$AnimationShowMenu.play("pop_in")
	else :
		$AnimationShowMenu.play_backwards("pop_in")
	visible = ! visible
	get_tree().paused = !get_tree().paused
	
func _on_options_button_pressed():
	$OptionsMenu/MenuPanel/MenuOption.visible = true

func _on_quit_button_pressed():
	#var main_scene = ResourceLoader.load("res://scenes/ui/main_menu.tscn")
	#get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	DialogManager.kill_dialog()
	hide()
	StageManager.change_stage("res://scenes/ui/main_menu.tscn")
	get_tree().paused = false
	
func _mouse_entered():
	hover_audio.play()
	
func _on_restart_button_pressed():
	restart_level.emit()
	_pause_game()
	
	
