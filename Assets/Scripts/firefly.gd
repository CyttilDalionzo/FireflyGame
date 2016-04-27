
extends RigidBody2D

var random_color

func _ready():
	set_fixed_process(true)
	randomize()
	random_color = Color(rand_range(0.0,1.0),rand_range(0.0,0.66),rand_range(0.0,0.33))
	get_node("Light2D").set_color(random_color)
	get_node("Sprite").set_modulate(random_color)
	var random_scale = rand_range(0.4,1.2)
	set_scale(Vector2(random_scale, random_scale))

func _fixed_process(delta):
	# Change direction at random points in time
	if(randf() > 0.95):
		var x_speed = rand_range(-60,60)
		var y_speed = rand_range(-60,60)
		
		# Keep fireflies within a fixed range of the approximate midpoint of the level;
		# This is just to make sure they stay within the level
		var my_pos = get_pos()
		if(my_pos.distance_to(Vector2(750,100)) > 100):
			while(Vector2(x_speed,y_speed).dot(my_pos) >= 0):
				x_speed = rand_range(-60,60)
				y_speed = rand_range(-60,60)
		
		apply_impulse(Vector2(), Vector2(x_speed,y_speed))

