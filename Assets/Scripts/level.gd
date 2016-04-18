
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("WorldEnvironment").get_environment().set_background(Environment.BG_CANVAS)


