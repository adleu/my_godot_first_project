extends CharacterBody2D

@export var speed = 250
@export var default_gravity = 30
@export var jump_force = 400

@export var friction = 30
@export var acceleration = 50

@export var run_multp = 1.75
@export var y_bounce_velocity = 720
@export var camera_bottom_limit = 1000000

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D


signal run

var running =  false
var last_y_velocity = 0
var jump_pressed = false
var gravity = default_gravity

#
#func _ready():
#	$FollowCam.limit_top = camera_bottom_limit - 480
#	$FollowCam.limit_top = 0
#	$FollowCam.limit_bottom = camera_bottom_limit
	
	

func _physics_process(delta):
	
	#gravity
	#if not is_on_floor():
	velocity.y += gravity
	if velocity.y > 1500:
		velocity.y = 1500
			
	#jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = - jump_force
		jump_pressed = true
	
	if Input.is_action_just_released("jump"):
		jump_pressed = false
		
################### TODO if planner is on ###################
#	if jump_pressed and last_y_velocity > 0:
#		gravity = default_gravity/5
#	else:
#		gravity = default_gravity
	
	#movement
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	
	if running:
		velocity.x = velocity.x * run_multp
	
	# walking direction
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
		
	update_animation(horizontal_direction)
	
	#run
	if Input.is_action_just_pressed("toggle_run"):
		toggle_run()
		
	if is_ready_to_bounce():
		velocity.y = - last_y_velocity/1.5
		$AudioBounce.play()
		
		
	last_y_velocity = velocity.y
	
	if velocity.y > 0:
		print(velocity.y)
	
	move_and_slide()
	
func update_animation(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			if running:
				ap.speed_scale = 1.5
			else:
				ap.speed_scale = 1
			ap.play("walk")
	else:
		ap.play("idle")
		
	if velocity.y > y_bounce_velocity:
		sprite.flip_v = true
	else :
		if velocity.y > 0:
			sprite.flip_v = false
		
############# bounce

func is_ready_to_bounce():
	if last_y_velocity > y_bounce_velocity and is_on_floor():
		return true
	return false
		
		
func toggle_run():
	run.emit()
	if running:
		running = false
	else:
		running = true
		

	
	
#func play_runnung_sound():
#	if velocity.x != 0 and is_on_floor() and $Timer.time_left <=0:
#		if running:
#			$AudioWalkMedium.pitch_scale = randf_range(0.8, 1.2)
#			$AudioWalkMedium.play()
#			$Timer.start(0.35/1.5)
#		else:
#			$AudioWalkMedium.pitch_scale = randf_range(0.8, 1.2)
#			$AudioWalkMedium.play()
#			$Timer.start(0.35)
