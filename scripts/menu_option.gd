extends CanvasLayer

@onready var fullscreen_button = $OptionsMenu/MarginContainer/HBoxContainer/MenuPanel/HBoxContainer/VBoxContainer2/FullscreenCheckBox
@onready var vsync_button = $OptionsMenu/MarginContainer/HBoxContainer/MenuPanel/HBoxContainer/VBoxContainer2/VSyncCheckBox
@onready var volume_slider = $OptionsMenu/MarginContainer/HBoxContainer/MenuPanel/HBoxContainer/VBoxContainer2/VolumeSlider
@onready var volume_indicator = $OptionsMenu/MarginContainer/HBoxContainer/MenuPanel/HBoxContainer/VBoxContainer3/VolumeIndicator

@onready var hover_audio = $HoverButtonAudio

@export var bus_name: String
var bus_index: int

var fullscreen 
var volume 
var vsync 

var scene_ready = false

func initialize_value():
	fullscreen = Global.get_fullscreen()
	volume = Global.get_volume()
	vsync = Global.get_vsync()

func _ready():
	initialize_value()
	bus_index = AudioServer.get_bus_index(bus_name)
	_update_button()
	scene_ready = true
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if visible:
			#reset the values before saving
			initialize_value()
			_update_button()
			#initilaize the last values
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
			visible = false
			
	
func _on_button_pressed():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	
	Global.set_config(fullscreen, vsync, volume)
	
	self.visible = false
		

func _on_fullscreen_check_box_toggled(button_pressed):
	fullscreen = ! fullscreen

func _on_v_sync_check_box_pressed():
	vsync = ! vsync

func _on_volume_slider_value_changed(value):
	volume = value
	_update_volume_indicator()
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	
func _set_visible():
	self.visible = true


func _on_visibility_changed():
	if visible and scene_ready:
		initialize_value()
		_update_button()
		
func _update_button():
	#volume = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	volume_slider.value = volume
	fullscreen_button.button_pressed = fullscreen
	vsync_button.button_pressed = vsync
	_update_volume_indicator()
	
		
func _mouse_entered():
	hover_audio.play()
	
func _update_volume_indicator():
	var vol_string= "%.0f" %(volume * 100)
	if vol_string.length() == 2:
		vol_string = " " + vol_string
	elif vol_string.length() == 1:
		vol_string = "  " + vol_string
	volume_indicator.text = vol_string +"%"
