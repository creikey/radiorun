extends RigidBody2D

var rock_numb = 0
export var max_rock_numb = 5

func _ready():
	set_rock_numb(rock_numb)

func set_rock_numb(new_numb):
	rock_numb = new_numb
	$sprite.texture = load("res://src/scenes/game/debris/" + str(rock_numb) + ".png")

func _on_VisibilityNotifier2D_screen_exited():
	#print("Destroying...")
	queue_free()
