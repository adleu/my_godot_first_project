extends Node2D

@onready var ap =  $AnimationPortal
@onready var ap_2 =  $AnimationCharacter
@onready var sprite_player =  $Control/Sprite2D2
@onready var sprite_portal =  $Sprite2D
@onready var landmark = $Control/landmark

var player

func _ready():
	landmark.queue_free()
	
	player = get_tree().get_first_node_in_group("player")
	player.hide()
	sprite_portal.hide()
	
	player.position = sprite_player.global_position
	player.set_process(false)
	player.set_physics_process(false)
	
	
func _enter_tree():
	play_spawn()
	

func play_spawn():
	await get_tree().create_timer(0.4).timeout
	
	sprite_portal.show()
	ap.play("portal_emerge")
	
	await ap.animation_finished
	ap.play("portal_idle")
	ap_2.play("player_fall")
	
	await get_tree().create_timer(0.5).timeout
	player.position = sprite_player.global_position
	
	sprite_player.hide()
	player.show()
	player.set_process(true)
	player.set_physics_process(true)
	
	await get_tree().create_timer(1).timeout
	
	ap.play("portal_disappear")
	await ap.animation_finished

	queue_free()
	
