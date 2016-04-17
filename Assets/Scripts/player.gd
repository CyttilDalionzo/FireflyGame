extends RigidBody2D

var jump_height = 350
var run_speed = 300
var strafe_force = 4

func are_feet_colliding():
	return get_node("Feet").get_overlapping_bodies().size() > 0

func is_left_colliding():
	return get_node("Left").get_overlapping_bodies().size() > 0

func is_right_colliding():
	return get_node("Right").get_overlapping_bodies().size() > 0

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	set_mode(MODE_CHARACTER)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _fixed_process(delta):
	set_linear_damp(0.5)
	
	if are_feet_colliding():
		floory_controls(delta)
	else:
		floaty_controls(delta)

func _input(event):
	if event.is_action_pressed("jump") and !event.is_echo():
		if are_feet_colliding():
			ground_jump()
		elif is_left_colliding():
			left_wall_jump()
		elif is_right_colliding():
			right_wall_jump()

func set_view_direction(is_left = null):
	if is_left == null:
		if get_linear_velocity().x < 0:
			get_node("Sprite").set_scale(0.4 * Vector2(-1, 1))
		else:
			get_node("Sprite").set_scale(0.4 * Vector2(1, 1))
		return
	
	if is_left:
		get_node("Sprite").set_scale(0.4 * Vector2(1, 1))
	else:
		get_node("Sprite").set_scale(0.4 * Vector2(-1, 1))

func ground_jump():
	set_linear_velocity( Vector2(get_linear_velocity().x, -jump_height) )
	print("ground jump")

func left_wall_jump():
	set_linear_velocity( 0.7 * Vector2(jump_height, -jump_height * 1.2) )
	print("wall jump left")

func right_wall_jump():
	set_linear_velocity( 0.7 * Vector2(-jump_height, -jump_height * 1.2) )
	print("wall jump right")

func floaty_controls(delta):
	set_linear_damp(0.9)
	
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2(), Vector2(-strafe_force, 0))
	if Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2(), Vector2(strafe_force, 0))
	
	set_view_direction()

func floory_controls(delta):
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2(), Vector2(-0.05 * (get_linear_velocity().x+run_speed), 0))
		get_node("Sprite").set_scale(0.4 * Vector2(-1, 1))
	elif Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2(), Vector2(-0.05 * (get_linear_velocity().x-run_speed), 0))
		get_node("Sprite").set_scale(0.4 * Vector2(1, 1))
	elif !Input.is_action_pressed("jump"):
		set_linear_damp(10.0)
