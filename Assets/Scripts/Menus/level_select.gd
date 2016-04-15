extends VBoxContainer

func _ready():
	get_node("Level1").grab_focus()

func _on_Level1_pressed():
	get_tree().change_scene("res://Levels/level1.scn")

func _on_Back_pressed():
	get_tree().change_scene("res://Levels/Menus/main_menu.scn")
