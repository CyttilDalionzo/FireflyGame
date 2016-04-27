extends Node2D

var firefly

func _ready():
	get_node("WorldEnvironment").get_environment().set_background(Environment.BG_CANVAS)
	# Load 20 fireflies, just to see what it would look and play like
	firefly = preload("res://Assets/Sprites/firefly.scn");
	for i in range(20):
		var new_firefly = firefly.instance()
		new_firefly.set_pos(Vector2(150,0))
		add_child(new_firefly)
		
