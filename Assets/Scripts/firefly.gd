
extends RigidBody2D

var randomColor

func _ready():
	set_fixed_process(true)
	randomize()
	randomColor = Color(rand_range(0.0,1.0),rand_range(0.0,0.66),rand_range(0.0,0.33))
	print(randomColor)
	get_node("Light2D").set_color(randomColor)
	get_node("Sprite").set_modulate(randomColor)
	var randomScale = rand_range(0.4,1.2)
	set_scale(Vector2(randomScale, randomScale))

func _fixed_process(delta):
	# Change direction at random points in time
	if(rand_range(0.0,1.0) > 0.95):
		var xSpeed = rand_range(-80,80)
		var ySpeed = rand_range(-80,80)
		
		# Keep fireflies within a fixed range of the approximate midpoint of the level;
		# This is just to make sure they stay within the level
		var myPos = get_pos()
		if(myPos.distance_to(Vector2(750,100)) > 100):
			while(Vector2(xSpeed,ySpeed).dot(myPos) >= 0):
				xSpeed = rand_range(-80,80)
				ySpeed = rand_range(-80,80)
		
		apply_impulse(Vector2(), Vector2(xSpeed,ySpeed))

