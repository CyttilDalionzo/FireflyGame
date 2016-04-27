extends RigidBody2D

var jump_height = 550
var run_speed = 300
var strafe_force = 4
var playerScale = 0.85

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
	
	var get_overlapping_bodies = get_node("BodyIK/OverallBody").get_overlapping_bodies()
	for i in range(get_overlapping_bodies.size()):
		if(get_overlapping_bodies[i].is_in_group("Fireflies")):
			get_overlapping_bodies[i].set_sleeping(true)
			get_overlapping_bodies[i].hide()
		elif(get_overlapping_bodies[i].is_in_group("Platforms")):
			set_pos(get_pos()+Vector2(get_overlapping_bodies[i].get_linear_velocity().x*delta,0))
	

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
			get_node("BodyIK").set_scale(playerScale * Vector2(-1, 1))
		else:
			get_node("BodyIK").set_scale(playerScale * Vector2(1, 1))
		return
	
	if is_left:
		get_node("BodyIK").set_scale(playerScale * Vector2(1, 1))
	else:
		get_node("BodyIK").set_scale(playerScale * Vector2(-1, 1))

func ground_jump():
	set_linear_velocity( Vector2(get_linear_velocity().x, -jump_height) )
	#print("ground jump")

func left_wall_jump():
	set_linear_velocity( 0.7 * Vector2(jump_height, -jump_height * 1.2) )
	#print("wall jump left")

func right_wall_jump():
	set_linear_velocity( 0.7 * Vector2(-jump_height, -jump_height * 1.2) )
	#print("wall jump right")

func floaty_controls(delta):
	set_linear_damp(0.9)
	get_node("FeetParticles").set_emitting(false)
	get_node("FeetParticlesGrass").set_emitting(false)
	
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2(), Vector2(-strafe_force, 0))
	if Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2(), Vector2(strafe_force, 0))
	
	set_view_direction()
	if(get_linear_velocity().y < 0):
		set_animation("jump")
	else:
		set_animation("fall")

func floory_controls(delta):
	if abs(get_linear_velocity().x) > 50:
		get_node("FeetParticles").set_emitting(true)
		if randf() > 0.97:
			get_node("FeetParticlesGrass").set_emitting(true)
	else:
		get_node("FeetParticles").set_emitting(false)
		get_node("FeetParticlesGrass").set_emitting(false)
	
	if Input.is_action_pressed("ui_left"):
		apply_impulse(Vector2(), Vector2(-0.05 * (get_linear_velocity().x+run_speed), -1))
		get_node("BodyIK").set_scale(playerScale * Vector2(-1, 1))
		set_animation("run")
	elif Input.is_action_pressed("ui_right"):
		apply_impulse(Vector2(), Vector2(-0.05 * (get_linear_velocity().x-run_speed), -1))
		get_node("BodyIK").set_scale(playerScale * Vector2(1, 1))
		set_animation("run")
	elif get_linear_velocity().y > 0:
		set_animation("slide")
	elif !Input.is_action_pressed("jump"):
		set_linear_damp(10.0)
		set_animation("idle")
	
	set_view_direction()

func set_animation(anim_name):
	if(get_node("BodyIK/AnimationPlayer").get_current_animation() != anim_name):
		get_node("BodyIK/AnimationPlayer").play(anim_name)
