
extends Node2D

var tilemap = []

# Tile Mapping: 
#	-2 = moving platform
#	-1 = nothing
#	0 -> 15 = the regular order of tiles as it is in tilemap.xml

func _ready():
	# Create Tilemap Data Here
	# (for testing) tilemap = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]
	
	#### Decide upon dimensions for the level
	var width = 40
	var height = 25
	
	randomize()
	
	tilemap.resize(height)
	
	##### Create Empty Border
	tilemap[0] = []
	tilemap[0].resize(width)
	tilemap[height-1] = []
	tilemap[height-1].resize(width)
	
	for j in range (width):
		tilemap[0][j] = -1
		tilemap[height-1][j] = -1
	
	#### First, create the 2D array (with an empty border around it), and the main islands
	for i in range(1,height-1):
		tilemap[i] = []
		tilemap[i].resize(width)
		tilemap[i][0] = -1
		tilemap[i][width-1] = -1
		for j in range(1,width-1):
			if(j > 2 && tilemap[i][j-1] == -1 && (tilemap[i][j-2] == 0 || (tilemap[i][j-2] == -1 && tilemap[i][j-3] == 0))):
				# Always at least three open spaces between subsequent horizontal islands
				tilemap[i][j] = -1
			elif(i > 2 && tilemap[i-1][j] == -1 && (tilemap[i-2][j] == 0 || (tilemap[i-2][j] == -1 && tilemap[i-3][j] == 0))):
				# Always at least three open spaces between subsequent vertical islands
				tilemap[i][j] = -1
			elif(randf() > 0.8):
				# Add some random open spaces
				tilemap[i][j] = -1
			else:
				# Fill the rest with ground tiles
				tilemap[i][j] = 0
	
	#### Remove ugly/odd/impossible stuff
	for i in range(1,height-1):
		for j in range(1,width-1):
			# Remove ugly singularities
			if(tilemap[i][j] == 0 && tilemap[i][j+1] == -1 && tilemap[i][j-1] == -1):
				tilemap[i][j] = -1
			elif(tilemap[i][j] == 0 && tilemap[i+1][j] == -1 && (tilemap[i][j-1] == -1 || tilemap[i][j+1] == -1)):
				tilemap[i][j] = 0
	
	#### Add slopes and cliffs
	for i in range(1,height-1):
		for j in range(1,width-1):
			# LEFT
			if(tilemap[i][j] == -1 && tilemap[i][j+1] == 0):
				# GRASS CLIFF
				if(tilemap[i-1][j] == -1 && tilemap[i+1][j] == -1):
					tilemap[i][j] = 5
				# SLOPE
				elif(tilemap[i-1][j] == -1 && (tilemap[i+1][j] == 0 || tilemap[i+1][j] == 6)):
					tilemap[i][j] = 7
				# MUD CLIFF
				elif(tilemap[i-1][j] == 0):
					tilemap[i][j] = 6
			# RIGHT
			elif(tilemap[i][j] == -1 && tilemap[i][j-1] == 0):
				# GRASS CLIFF
				if(tilemap[i-1][j] == -1 && tilemap[i+1][j] == -1):
					tilemap[i][j] = 3
				# SLOPE
				elif(tilemap[i-1][j] == -1 && (tilemap[i+1][j] == 0 || tilemap[i+1][j] == 4)):
					tilemap[i][j] = 9
				# MUD CLIFF
				elif(tilemap[i-1][j] == 0):
					tilemap[i][j] = 4
	
	#### Change some odd tile arrangements that have been missed
	for i in range(1,height-1):
		for j in range(1,width-1):
			# Turn mud tiles into cliffs if they happen to end up at the bottom edges
			if(tilemap[i][j] == 0 && tilemap[i-1][j] == 0 && tilemap[i][j+1] == -1 && tilemap[i+1][j] == -1):
				tilemap[i][j] = 4
			elif(tilemap[i][j] == 0 && tilemap[i-1][j] == 0 && tilemap[i][j-1] == -1 && tilemap[i+1][j] == -1):
				tilemap[i][j] = 6
			# Turn mud tiles into slopes if they happen to end up at the top edges
			elif(tilemap[i][j] == 0 && tilemap[i+1][j+1] == 9):
				tilemap[i][j] = 9
			elif(tilemap[i][j] == 0 && tilemap[i+1][j-1] == 7):
				tilemap[i][j] = 7
			
			# Diagonally touching tiles (LEFT, RIGHT)
			if(tilemap[i][j] != -1 && tilemap[i+1][j+1] != -1 && tilemap[i+1][j] == -1 && tilemap[i][j+1] == -1):
				if(tilemap[i+1][j+2] == 0):
					if(tilemap[i-1][j] == -1):
						tilemap[i][j] = 3
					else:
						tilemap[i][j] = 4
					tilemap[i+1][j+1] = 7
				else:
					tilemap[i][j] = -1
					tilemap[i+1][j+1] = -1
			elif(tilemap[i][j] != -1 && tilemap[i-1][j-1] != -1 && tilemap[i+1][j] == -1 && tilemap[i][j-1] == -1):
				if(tilemap[i+1][j-2] == 0):
					if(tilemap[i-1][j] == -1):
						tilemap[i][j] = 5
					else:
						tilemap[i][j] = 6
					tilemap[i+1][j-1] = 9
				else:
					tilemap[i][j] = -1
					tilemap[i+1][j-1] = -1
			
			if(tilemap[i][j] == 0 && (tilemap[i+1][j] == 7 || tilemap[i+1][j] == 9)):
				tilemap[i][j] = -1
	
	#### Add grass and slope helpers
	for i in range(1,height-1):
		for j in range(1, width-1):
			# SLOPE HELPERS
			if(tilemap[i][j] == 0):
				if(tilemap[i-1][j] == 7):
					tilemap[i][j] = 8
				elif(tilemap[i-1][j] == 9):
					tilemap[i][j] = 10
			# FLOURISHES (stones, flowers)
			if(tilemap[i][j] == -1 && tilemap[i+1][j] == 0):
				tilemap[i][j] = round(randf()*3.95+11.55)
			# GRASS
			elif((tilemap[i-1][j] == -1 || tilemap[i-1][j] >= 12) && tilemap[i][j] == 0):
				tilemap[i][j] = 1
	
	#### Lastly, add the big sprites, such as trees, moving platforms, lanterns, etcetera
	for i in range(1,height-1):
		for j in range (1,width-1):
			if(j > 2 && tilemap[i][j] == -1 && tilemap[i][j-1] == -1 && tilemap[i][j-2] == -1 && tilemap[i-1][j] == -1 && tilemap[i-1][j-1] == -1 && tilemap[i-1][j-2] == -1 && randf() > 0.87):
				tilemap[i][j-1] = -2
				
	
	##### Set the right cells to the right type of cell within the tilemap
	##### by looping through the 2D tilemap array
	for i in range(height):
		for j in range(width):
			if(tilemap[i][j] >= 0):
				get_node("TileMap").set_cell(j*2,i*2,tilemap[i][j])
			elif(tilemap[i][j] == -2):
				var moving_platform = preload("res://Assets/Sprites/platform.scn").instance();
				moving_platform.set_pos(Vector2(j*50+25,i*50+25))
				add_child(moving_platform)


