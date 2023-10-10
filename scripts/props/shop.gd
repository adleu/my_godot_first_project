extends Sprite2D

@onready var interaction_area = $InteractionArea
@onready var shop_menu = $ShopMenu
@onready var player = get_tree().get_first_node_in_group("player")


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		_on_back_button_pressed()
	
func _ready():
	interaction_area.interact = Callable(self, "_open_shop")

func _open_shop():
	shop_menu.show()
	Global.interface = true
	player.set_process(false)
	player.set_physics_process(false)
	

func _on_back_button_pressed():
	player.set_process(true)
	player.set_physics_process(true)
	Global.interface = false	
	shop_menu.hide()
