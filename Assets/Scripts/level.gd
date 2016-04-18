extends Node2D

func _ready():
	get_node("WorldEnvironment").get_environment().set_background(Environment.BG_CANVAS)
