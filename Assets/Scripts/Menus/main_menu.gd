extends VBoxContainer

func _ready():
	get_node("Start").grab_focus()

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/Menus/level_select.scn")

func _on_Exit_pressed():
	get_tree().quit()
