extends Sprite2D

var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_right") and not done:
		self.visible = false
		$MusicTrack1.play()
		done = true


func _on_music_track_1_finished():
	$MusicTrack1.play()
