
extends RigidBody2D

var main_direction = 1.0
var move_speed = 40

func is_left_colliding():
	return get_node("Left").get_overlapping_bodies().size() > 0

func is_right_colliding():
	return get_node("Right").get_overlapping_bodies().size() > 0

func _ready():
	set_fixed_process(true)
	set_mode(MODE_KINEMATIC)

func _fixed_process(delta):
	if(is_right_colliding() && main_direction == 1.0):
		main_direction = -1.0
	elif(is_left_colliding() && main_direction == -1.0):
		main_direction = 1.0
	set_pos(get_pos()+Vector2(main_direction*delta*move_speed,0))
	set_linear_velocity(Vector2(main_direction*delta*move_speed,0))


