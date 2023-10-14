extends CharacterBody2D

class_name Player

@export var speed = 250
@export var default_gravity = 30
@export var jump_force = 400

@export var friction = 50
@export var acceleration = 30

@export var run_multp = 1.3
@export var y_bounce_velocity = 720

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

var jump_buffer_time = 0.1
var jump_buffer_timer:  float = 0
var coyote_time = 0.1

signal run
signal ui_add_bonus
signal ui_remove_bonus

var running =  Global.running
var last_y_velocity = 0
var jump_pressed = false
var gravity = default_gravity

var bonus = 0
var max_bonus = 3
# un bonus a la fois sinon buffer
var bonus_active = false 
var bonus_buffer : Array

enum BonusType{
	JUMP = 1,
	GLIDE = 2
	}

var bonus_jump_left = 0
var jumped = false
var jump_particules = preload("res://scenes/entities/items/animations/jump_particules.tscn")
var glide_bonus_active = false
var jump_is_pressed = false

var glide_buffer = 0
var glide_buffer_timer = 0.2
const glide_velocity = 100
var gliding = false
@onready var glide_particules = $GlideParticules
@onready var audio_glide = $AudioGlide

func _process(delta):
	if jump_buffer_timer >= 0:
		jump_buffer_timer -= delta
		
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
		jump_is_pressed = true
		
	if jump_is_pressed and ! is_on_floor():
		glide_buffer += delta
		
	if Input.is_action_just_released("jump"):
		glide_buffer = 0
		jump_is_pressed =  false
		
	
	

func _physics_process(delta):
	
	var horizontal_direction : Vector2 = input()
	
	if horizontal_direction != Vector2.ZERO:
		accelerate(horizontal_direction)
	else:
		add_friction()
		
	update_animation(horizontal_direction)
	
	#run
	if Input.is_action_just_pressed("toggle_run"):
		toggle_run()
		
		
	if is_ready_to_bounce():
		velocity.y = - last_y_velocity/1.5
		$BounceParticules.emitting = true
		$AudioBounce.play()
		
	
	last_y_velocity = velocity.y
	
	move_and_slide()
	jump(horizontal_direction)
	_glide(horizontal_direction)
	
	
	
func update_animation(horizontal_direction):
	if horizontal_direction.x != 0:
		sprite.flip_h = (horizontal_direction.x == -1)
		
	if is_on_floor():
		if horizontal_direction.x == 0:
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
		


func is_ready_to_bounce():
	if last_y_velocity > y_bounce_velocity and is_on_floor():
		return true
	return false
		
		
func toggle_run():
	run.emit()
	Global.change_run_state()
	running = !running
		
		
func add_friction():
	velocity.x = velocity.move_toward(Vector2.ZERO, friction).x
	
func accelerate(direction):
	var run = 1
	if running and not gliding:
		run = run_multp
	velocity.x = velocity.move_toward(speed * direction * run, acceleration).x
	
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	
	return input_dir.normalized()
	
func jump(direction):
	if can_jump() == 1 and jump_buffer_timer > 0:
		velocity.y = - jump_force
		jumped = true
		
	elif can_jump() == 2 and Input.is_action_just_pressed("jump") && (!$RayCast2D.is_colliding() and !$RayCast2D2.is_colliding()):
		_double_jump(direction)
		
	else:
		if not is_on_floor():
			velocity.y += gravity
			if velocity.y > 1500:
				velocity.y = 1500
				
		if is_on_floor():
			jumped = false
		
#return 0: can't jump
#return 1 : can jump beacause on floor
#return 2 : can jump by bonus jump	
func can_jump():
	if ($RayCast2D.is_colliding() or $RayCast2D2.is_colliding()) and not jumped:  
		$CoyoteTimer.start(coyote_time)
		return 1
	if not $CoyoteTimer.is_stopped() and not jumped:
		return 1
	if jumped and bonus_jump_left > 0:
		return 2
		
	return 0
	
func add_jump():
	bonus_jump_left += 1
	
func add_bonus(bonus_class) -> bool:
	
	if bonus == max_bonus:
		return false
	
	var texture = bonus_class.get_texture()
	var type = bonus_class.get_type()
	ui_add_bonus.emit(bonus_class)
	
	bonus_class.get_audio().play() 
	
	if bonus_active :
		bonus_buffer.append(type)
	else:
		apply_bonus(type)
	bonus += 1
	return true
	
func apply_bonus(type):
	match type:
		BonusType.JUMP:
			bonus_jump_left += 1
		BonusType.GLIDE:
			glide_bonus_active = true
	bonus_active = true
		
func use_bonus():
	bonus -= 1
	bonus_active = false
	ui_remove_bonus.emit()
	if !bonus_buffer.is_empty():
		apply_bonus(bonus_buffer.pop_front())
		
func _double_jump(direction):
	bonus_jump_left -= 1
	velocity.y = - jump_force * 1.2
	jumped = true
	velocity.x = velocity.x * 2
	$AudioDoubleJump.play()
	use_bonus()
	
	#### rotation animation
	if direction.x != 0:
		var dup_ap = ap.duplicate()
		add_child(dup_ap)

		if direction.x == -1:
			dup_ap.play_backwards("rotation")
		else:
			dup_ap.play("rotation")

		_free_dup_ap(dup_ap)
	
	
	
	#temp instance will autodestruct after job done
	var temp_instance = jump_particules.instantiate()
	add_child(temp_instance) 
	temp_instance.emit_particules()
	
func _free_dup_ap(dup_ap):
	await dup_ap.animation_finished
	dup_ap.queue_free()


func _glide(direction):
	if glide_buffer > glide_buffer_timer and !is_on_floor() and last_y_velocity > 0 and (gliding or glide_bonus_active):
		disable_glide()
		velocity.y = glide_velocity
		rotation = -25 * direction.x   
		glide_particules.emitting = true
		gliding = true
	else:
		if not gliding:
			return
		rotation = 0 
		glide_particules.emitting = false
		gliding = false

func disable_glide():
	if glide_bonus_active:
		audio_glide.play()
		glide_bonus_active = false
		use_bonus()
	
	
	

