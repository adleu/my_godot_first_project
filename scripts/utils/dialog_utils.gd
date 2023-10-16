static func _load_dialogue(path):
	if not FileAccess.file_exists(path):
		printerr(path + " not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())
	

static func get_lines(state, dialog_data):
	state = str(state)
	var res_dialog : Array[String] = []
	var array_dialog = []
	
	if dialog_data[state][0] is Array :
		array_dialog = dialog_data[state][randi() % dialog_data[state].size()]
		
	if dialog_data[state][0] is String :
		array_dialog = dialog_data[state]
		
	for d in array_dialog.size():
		res_dialog.append(array_dialog[d] as String)
	
	return res_dialog
