extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var audio = $AudioStreamPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@export var texture : Texture2D


func _ready():
	interaction_area.interact = Callable(self, "_take_orb")

func _take_orb():
	if player.add_bonus(self):
		#audio.play()
		_disable_orb()
		
func _disable_orb():
	hide()
	$InteractionArea.body_exited.emit() 
	$InteractionArea/CollisionShape2D.disabled = true
	await get_tree().create_timer(5).timeout
	queue_free()
	
func get_descripion() -> String:
	return "hold jump to glide"
	
func get_type() -> Player.BonusType:
	return Player.BonusType.GLIDE
	
func get_texture() -> Texture2D:
	return texture

func get_audio():
	return audio

