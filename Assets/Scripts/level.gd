extends Node2D

var firefly

func _ready():
	get_node("WorldEnvironment").get_environment().set_background(Environment.BG_CANVAS)
	firefly = preload("res://Assets/Sprites/firefly.scn");
	for i in range(0,20):
		var newF = firefly.instance()
		newF.set_pos(Vector2(150,0))
		add_child(newF)
		
