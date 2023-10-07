extends Area2D

var valley = preload("res://scenes/levels/lobby.tscn")

func _on_body_entered(body):
	StageManager.change_stage("res://scenes/levels/lobby.tscn")
