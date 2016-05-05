
extends Node

export(int) var bridge_length = 5
var parts_array = []

func _ready():
	parts_array.resize(bridge_length)
	var left_pos_x = get_node("LeftEnd").get_pos().x
	var left_pos_y = get_node("LeftEnd").get_pos().y
	var w = 63
	get_node("OriginalNodes/Joint").set_softness(0.05)
	
	for i in range(bridge_length):
		var new_part = get_node("OriginalNodes/MiddlePart").duplicate()
		new_part.set_pos(Vector2(left_pos_x+i*w+0.5*w,left_pos_y-0.5*w))
		var name = str("MiddlePart",i)
		new_part.set_name(name)
		parts_array.append(name)
		add_child(new_part)
		var new_joint = get_node("OriginalNodes/Joint").duplicate()
		add_child(new_joint)
		if(i == 0):
			new_joint.set_pos(Vector2(left_pos_x,left_pos_y))
			new_joint.set_node_a(str("../",name))
			#new_joint.set_node_b("../LeftEnd")
		else:
			new_joint.set_pos(Vector2(new_part.get_pos().x-0.5*w,left_pos_y))
			new_joint.set_node_a(str("../",parts_array[parts_array.size()-2]))
			new_joint.set_node_b(str("../",name))
	
	# Last Joint, fixed to right edge
	var new_joint = get_node("OriginalNodes/Joint").duplicate()
	add_child(new_joint)
	var last_node = parts_array[parts_array.size()-1]
	new_joint.set_pos(Vector2(get_node(last_node).get_pos().x+0.5*w,left_pos_y))
	new_joint.set_node_a(str("../",last_node))
	#new_joint.set_node_b("../RightEnd")
	print(new_joint.get_pos())
	get_node("RightEnd").set_pos(Vector2(get_node(last_node).get_pos().x+0.5*w,left_pos_y))


