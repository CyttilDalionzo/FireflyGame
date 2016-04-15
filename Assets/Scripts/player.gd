extends RigidBody2D

var jump_height = 200
var run_speed = 120
var strafe_force = 2

func is_colliding():
	return get_node("Feet").get_overlapping_bodies().size() > 0


func _ready():
	#set_process_input(true)
	set_fixed_process(true)
	set_mode(MODE_CHARACTER)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
	# Ignore collisions with ourselves
	#get_node("Feet").add_exception(self)

func _fixed_process(delta):
	set_linear_damp(0.5)
	
	if !is_colliding():
		floaty_controls(delta)
		return
	
	if Input.is_action_pressed("jump"):
		set_linear_velocity(Vector2(get_linear_velocity().x, -jump_height))
	elif Input.is_action_pressed("ui_left"):
		set_linear_velocity(Vector2(-run_speed, get_linear_velocity().y))
	elif Input.is_action_pressed("ui_right"):
		set_linear_velocity(Vector2(run_speed, get_linear_velocity().y))
	else:
		set_linear_damp(10.0)

func floaty_controls(delta):
	set_linear_damp(0.9)
	
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2(), Vector2(-strafe_force, 0))
	if Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2(), Vector2(strafe_force, 0))

func _input(event):
	if event.is_action_released("ui_left") and is_colliding():
		set_linear_velocity(Vector2())
	if event.is_action_released("ui_right") and is_colliding():
		set_linear_velocity(Vector2())