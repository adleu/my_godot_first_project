extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@export var texture : Texture2D

func _ready():
	interaction_area.interact = Callable(self, "_take_orb")
#	$BonusJumpEffect.hide()

func _take_orb():
	if player.add_bonus(Player.BonusType.JUMP, texture):
		$Sprite2D.hide()
		$AudioStreamPlayer.play()
		$InteractionArea/CollisionShape2D.disabled = true

	
	
