extends TileMap

@export var grid_width := 20
@export var grid_length := 20
@export_range(0.0, 1.0) var simu_tick := 0.5

@onready var timer = $Timer

var offset = Vector2i.ZERO


var Grid: Array[Array] = []

enum CELL_STATUS {
	DEAD = 0,
	ALIVE = 1
}

var tilesetID := 0
var layer := 0
var black_tile = Vector2i(1, 0)
var white_tile = Vector2i(0, 0)

var simulate := false

func _ready():
	for x in range(grid_width):
		Grid.append([])
		for y in range(grid_length):
			Grid[x].append(Cell.new())
	
	offset = Vector2i(grid_width / 2, grid_length / 2)

	timer.wait_time = simu_tick
	
	drawGrid()
	
func _process(_delta):
	
	if Input.is_action_just_pressed("Add_Tile"):
		changeTile(self, CELL_STATUS.ALIVE)
	if Input.is_action_just_pressed("Delete_Tile"):
		changeTile(self, CELL_STATUS.DEAD)
	if Input.is_action_just_pressed("Step"):
		step()
	if Input.is_action_just_pressed("Play"):
		simulate = !simulate
		
	drawGrid()
	
func changeTile(tilemap: TileMap, alive: CELL_STATUS):
	var mouse_pos = tilemap.get_local_mouse_position()
	var tile_clicked = tilemap.local_to_map(mouse_pos)
	if tilemap.get_cell_alternative_tile(layer, tile_clicked) != -1:
		(Grid[tile_clicked.x - offset.x][tile_clicked.y - offset.y] as Cell).is_alive = alive

func step():
	for x in range(grid_width):
		for y in range(grid_length):
			var cell = Grid[x][y] as Cell

			for n1 in range(-1, 2):
				for n2 in range(-1, 2):
					if inBounds(x + n1, y + n2, grid_width, grid_length):
						var neighbor = Grid[x + n1][y + n2] as Cell
						if neighbor.is_alive && !(x == x + n1 && y == y + n2):
							cell.neighbors_count += 1
	
	for x in range(grid_width):
		for y in range(grid_length):
			var cell = Grid[x][y] as Cell
			cell.update_alive_status()
	pass

func drawGrid():
	for x in range(grid_width):
		for y in range(grid_length):
			var coords = Vector2i(x, y)
			var gridCell = Grid[x][y] as Cell
			var newTile = white_tile if gridCell.is_alive else black_tile
			self.set_cell(layer, coords - offset, tilesetID, newTile)

func inBounds(lower_x, lower_y, higher_x, higher_y) -> bool:
	return lower_x >= 0 && lower_y >=0 && lower_x < higher_x && lower_y < higher_y


func _on_timer_timeout():
	if simulate:
		step()
	pass # Replace with function body.
