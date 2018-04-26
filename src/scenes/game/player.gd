extends Area2D

signal death

enum STATES { flying, flipping, falling, rising, reorienting, dead }
var state

export var upper_bounds = 0.5
export (NodePath) var bg_sprite
export var flying_variation = 30
export var flying_divisor = 8
export var flying_horizontal_speed = 5.0
export var fall_speed = 0.2
export var rise_speed = 0.5

var falling_velocity = 0
var rising_velocity = 0
var flying_counter = 0

func _ready():
	state = STATES.flying
	$AnimatedSprite.set_animation("flying")
	goto_upper_bounds()
	set_process(true)

func _process(delta):
	if(state == STATES.flying):
		# Transition to flipping if press up
		if(Input.is_action_pressed("game_up")):
			$AnimatedSprite.play("flipping")
			state = STATES.flipping
		flying_counter += 1
		relative_move(Vector2(0,sin(flying_counter/flying_divisor)*flying_variation))
		if(Input.is_action_pressed("game_left")):
			relative_move(Vector2(-flying_horizontal_speed,0))
		if(Input.is_action_pressed("game_right")):
			relative_move(Vector2(flying_horizontal_speed,0))
		var sprite_width = $AnimatedSprite.frames.get_frame("flying", $AnimatedSprite.frame).get_width()
		sprite_width *= $AnimatedSprite.scale.x
		global_position.x = clamp(global_position.x, 0, OS.get_window_size().x-sprite_width)
	elif(state == STATES.flipping):
		# Transition to falling if done flipping
		if($AnimatedSprite.frame >= $AnimatedSprite.frames.get_frame_count("flipping")-1):
			$AnimatedSprite.play("falling")
			falling_velocity = 0
			state = STATES.falling
	elif(state == STATES.falling):
		# Transition if trying to reorient
		if(Input.is_action_pressed("game_up")):
			$AnimatedSprite.play("reorienting")
			state = STATES.reorienting
		# Emit death if the player goes off screen
		if(global_position.y > OS.get_window_size().y):
			emit_signal("death")
			state = STATES.dead
		falling_velocity += fall_speed
		relative_move(Vector2(0,falling_velocity))
		if(Input.is_action_pressed("game_left")):
			relative_move(Vector2(-flying_horizontal_speed,0))
		if(Input.is_action_pressed("game_right")):
			relative_move(Vector2(flying_horizontal_speed,0))
	elif(state == STATES.reorienting):
		# Transition to going up
		if($AnimatedSprite.frame >= $AnimatedSprite.frames.get_frame_count("reorienting")-1):
			state = STATES.rising
			rising_velocity = 0
			$AnimatedSprite.play("flying")
	elif(state == STATES.rising):
		# Continue going up until it's at the peak
		if(global_position.y <= OS.get_window_size().y*upper_bounds):
			state=STATES.flying
		rising_velocity += rise_speed
		relative_move(Vector2(0,-rising_velocity))
	elif(state == STATES.dead):
		pass

func goto_upper_bounds():
	var target_pos = Vector2(OS.get_window_size().x/2, upper_bounds*OS.get_window_size().y)
	relative_move(target_pos-global_position)

func relative_move(inVec):
	global_position += inVec