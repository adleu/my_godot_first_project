extends Control

var radius = 5  # Le rayon initial du cercle
var maxRadius = 1500  # Le rayon maximal que le cercle atteindra
var growthSpeed = 100  # La vitesse à laquelle le cercle s'agrandit




func _process(delta):
	if radius < maxRadius:
		radius += growthSpeed * delta
	else:
		radius = maxRadius
	
	queue_redraw()

func _draw():
	draw_circle(Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2), radius, Color(0, 0, 0, 1))
	# Effacer l'écran avec une couleur noire
	draw_rect(Rect2(Vector2(0, 0), get_viewport_rect().size), Color(0, 0, 0, 1))
	
	# Dessiner le cercle autour du joueur en couleur transparente (Alpha = 0)
#	draw_circle(Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2), radius, Color(0, 0, 0, 1))

