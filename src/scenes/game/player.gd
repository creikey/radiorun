extends KinematicBody2D

export var upper_bounds = 800.0
export var lower_bounds = 400.0
export var vert_move_speed = 3.0
export var vert_max_velocity = 8.0
export var horz_move_speed = 1.0
export var horz_max_velocity = 5.0
export var horz_dampening = 0.5

enum direction { UP, DOWN, LEFT, RIGHT, STATIONARY }
var curverdir = direction.UP
var curhorzdir = direction.STATIONARY
var velocity = Vector2()

func _ready():
	set_physics_process(true)
	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("game_left")):
		curhorzdir = direction.LEFT
	elif(Input.is_action_pressed("game_right")):
		curhorzdir = direction.RIGHT
	else:
		curhorzdir = direction.STATIONARY
	if(Input.is_action_just_pressed("game_up")):
		curverdir = flip_horz_dir(curverdir)

func _physics_process(delta):
	if(curhorzdir == direction.STATIONARY):
		velocity.x = 0
	elif(curhorzdir == direction.LEFT):
		velocity.x -= horz_move_speed
	elif(curhorzdir == direction.RIGHT):
		velocity.x += horz_move_speed
	velocity.x = clamp( velocity.x, -horz_max_velocity, horz_max_velocity )
	if(velocity.x != 0):
		velocity.x += (velocity.x/abs(velocity.x))*horz_dampening*-1
	if(curverdir == direction.UP):
		velocity.y -= vert_move_speed
	elif(curverdir == direction.DOWN):
		velocity.y += vert_move_speed
	velocity.y = clamp( velocity.y, -vert_max_velocity, vert_max_velocity )
	move_and_collide(velocity)
	global_position.y = clamp( global_position.y, lower_bounds, upper_bounds )

func flip_horz_dir(in_dir):
	if(in_dir == direction.UP):
		return direction.DOWN
	else:
		return direction.UP