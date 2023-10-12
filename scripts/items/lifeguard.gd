extends Area2D

@export var min_attempt = 10
@onready var label = $CanvasLayer/MarginContainer/Label
@onready var ghost = $Ghost
@onready var anim_circle = $ColorRect/AnimationPlayer
@onready var color_rect = $ColorRect



var attempt = 0
var active = false
var tried = false

var _player


func _ready():
	_player = get_tree().get_first_node_in_group("player")
	

func _process(delta):
	if Input.is_action_just_pressed("lifeguard"):
		if active and ghost.visible:
			label.hide()
			transition()
		
func lifeguard():
	for node in get_tree().get_nodes_in_group("lifeguard"):
		if node != self:
			node.disable()
	active = true
	ghost.show()
	label.show()
	await get_tree().create_timer(10).timeout
	label.hide()
	
func disable():
	ghost.hide()
	active = false
	if attempt >= min_attempt:
		attempt = min_attempt - 1

func _on_save_spot_body_entered(body):
	if active :
		ghost.hide()
		label.hide()
	tried = true
	
func _failed(body):
	if tried :
		tried = false
		attempt += 1
		
		if attempt == min_attempt:
			lifeguard()

func _on_save_spot_body_exited(body):
	if active :
		await get_tree().create_timer(4).timeout
		ghost.show()
		
func transition():
	color_rect.global_position = _player.position - color_rect.size / 2
	color_rect.show()
	anim_circle.play_backwards("trans_out")
	await anim_circle.animation_finished
	color_rect.global_position = global_position - color_rect.size / 2
	anim_circle.play("trans_out")
	_player.position = position
	await anim_circle.animation_finished
	color_rect.hide()
	
	
		
