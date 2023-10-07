extends Area2D

@export var display_text = ""

func _ready():
	$Label.hide()
	$Label.text = display_text

func _on_body_entered(body):
	if body.is_in_group("player"):
		$Label.show()


func _on_body_exited(body):
	if body.is_in_group("player"):
		$Label.hide()
