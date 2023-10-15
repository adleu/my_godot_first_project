extends MarginContainer
@onready var ap = $AnimationPlayer
@onready var content = $PanelContainer/VBoxContainer/RichTextLabel

var _pos = -1
	
func move_down():
	if _pos == -1:
		_pop_in()
		_pos += 1
	elif _pos ==0 :
		_pos += 1
		_pop_out()

func move_up():
	if _pos == 0:
		_pop_in(true)
		_pos -= 1
	elif _pos ==1 :
		_pos -= 1
		_pop_out(true)	

func _pop_in(backward = false):
	if backward:
		ap.play_backwards("pop_in")
	else:
		ap.play("pop_in")
	
func _pop_out(backward = false):
	if backward:
		ap.play_backwards("pop_out")
	else:
		ap.play("pop_out")
	
func set_content(text : String):
	content.text = text
	
