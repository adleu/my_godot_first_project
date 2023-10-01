extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D

func _ready():
	interaction_area.interact = Callable(self, "_take_orb")

func _take_orb():
	hide()
	$AudioStreamPlayer.play()
	$InteractionArea/CollisionShape2D.disabled = true
