extends VBoxContainer

var firefly

func _ready():
	get_node("Start").grab_focus()
	firefly = preload("res://Assets/Sprites/firefly.scn");
	for i in range(0,20):
		var newF = firefly.instance()
		add_child(newF)

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/Menus/level_select.scn")

func _on_Exit_pressed():
	get_tree().quit()
