
extends RigidBody2D

var randomColor

func _ready():
	set_fixed_process(true)
	randomize()
	randomColor = Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0))
	print(randomColor)
	get_node("Light2D").set_color(randomColor)
	get_node("Sprite").set_modulate(randomColor)

func _fixed_process(delta):
	if(rand_range(0.0,1.0) > 0.95):
		apply_impulse(Vector2(), Vector2(rand_range(-100,100),rand_range(-100,100)))

