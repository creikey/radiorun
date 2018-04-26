extends Area2D

var rock_numb = 0
var rot_speed = 2.0

func _ready():
	set_process(true)

func set_rock_numb(new_numb):
	rock_numb = new_numb
	$sprite.texture = load("res://src/scenes/game/debris/" + str(rock_numb) + ".png")