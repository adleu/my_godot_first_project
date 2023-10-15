extends Sprite2D

var min_energy = 0.2
var max_energy = 0.9
@onready var light = $PointLight2D

func _process(delta):
	var new_energy = lerp(min_energy, max_energy, randf())  # Utilisez randf() pour générer une valeur aléatoire entre 0 et 1
	light.energy = new_energy

	# L'effet de scintillement est basé sur le temps et la vitesse

