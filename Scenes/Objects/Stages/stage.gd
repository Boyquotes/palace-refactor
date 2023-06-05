# inherited by actual stages
# inheritors have custom generation code, visuals, grid sizes, etc.
extends Node2D

signal unit_spawned

const TILE_SCENE = preload("res://Scenes/System/tile.tscn")
const CELL_SIZE = Vector2i(25, 25)

enum MODES {SPAWN_SELECT, GRID_SELECT, ACTION_SELECT, WATCH_PHASE}
enum PHASES {PLAYER, ENEMY}

# ---------- INITIALIZATION VARS ------------------
@export var grid_size = Vector2i(7,4)
@export var difficulty = 0

# ------ VARIABLES FOR FUNCTIONALITY --------------
var current_mode = MODES.GRID_SELECT # affects what player input does
var current_phase = PHASES.PLAYER # keeps track of player/enemy phase
var selected_action : Action
var selected_tile
var selected_unit

var button_dict = {} # helps determine which buttons are available upon unit selection

#==========================================================================
#==========================================================================

func _ready():
	# connect signals
	SignalBus.tile_selected.connect(_on_Tile_Selected)
	SignalBus.action_chosen.connect(_on_Action_Chosen)
	SignalBus.end_phase.connect(_on_End_Phase)
	
	# setup grid
	Global.grid = Grid.new(grid_size, CELL_SIZE)
	
	var base_p = Vector2i(320 - (grid_size * CELL_SIZE / 2).x, 240 - (grid_size * CELL_SIZE).y)
	$Grid.position = base_p
	$Overlay.position = base_p
	$Units.position = base_p
	$Enemies.position = base_p
	
	# initialize grid related globals
	for i in Global.grid.size.x:
		for j in Global.grid.size.y:
			var new_tile = TILE_SCENE.instantiate()
			new_tile.position = CELL_SIZE * Vector2i(i, j)
			new_tile.grid_p = Vector2i(i, j)
			$Grid.add_child(new_tile)
			
			Global.grid_to_tile[new_tile.grid_p] = new_tile
			Global.grid_to_unit[new_tile.grid_p] = null
			Global.grid_to_enemy[new_tile.grid_p] = null
			Global.grid_to_terrain[new_tile.grid_p] = null
			
	# generate stage
	_generate_stage()
	
	# initialize units
	_initialize_units()
	
	# initialize HUD / UI
	_initialize_UI()
	
	# wait for player input
	_spawn_units()

#----------- SIGNAL FUNCTIONS ----------------------------------
func _on_Tile_Selected(tile):
	match current_mode:
		MODES.GRID_SELECT:
			if selected_tile == tile:
				tile.selected = false
				selected_tile = null
				deselect_unit()
				return
			if selected_tile:
				tile.selected = false
				selected_tile = null
				deselect_unit()
			if Global.grid_to_unit[tile.grid_p]:
				tile.selected = true
				selected_tile = tile
				select_unit(Global.grid_to_unit[selected_tile.grid_p])
		MODES.ACTION_SELECT:
			if tile.available:
				# play sfx, set unit as inactive, check other units, end phase
				#Global.play_sfx('blip2.wav')
				current_mode = MODES.GRID_SELECT # temp
				selected_tile.selected = false
				selected_tile = null
				# move unit
				selected_unit.perform_action(selected_action, tile.grid_p)
				deselect_unit()
			else:
				current_mode = MODES.GRID_SELECT
			clear_tiles()
		MODES.SPAWN_SELECT:
			pass
		MODES.WATCH_PHASE:
			pass

func _on_Action_Chosen(action):
	current_mode = MODES.ACTION_SELECT
	selected_action = action
	
	clear_tiles()
	
	var base = selected_unit.grid_p
	for v in action.scope:
		var p = base
		if selected_unit.flip_h: p += Vector2i(-v.x, v.y)
		else: p += v
		if Global.grid.is_within_bounds(p):
			Global.grid_to_tile[p].set_available(action.type)
	
func _on_End_Phase():
	pass

#=======================================================
#-------------------INTERNAL FUNCTIONS-------------------------
# add unit scenes to Units node, keep invisible
func _initialize_units():
	pass

# buttons and status bars
func _initialize_UI():
	pass

# wait for player to click starting squares until all units spawned.
# temp: just pick 4 and start game.
func _spawn_units():
	pass

#================================================================
#---------------EXTERNAL FUNCTIONS-----------------------------
func select_unit(unit):
	pass
	
func deselect_unit():
	pass
	
func clear_tiles():
	for i in range(Global.grid.size.x):
		for j in range(Global.grid.size.y):
			Global.grid_to_tile[Vector2i(i,j)].clear()

#==============================================================
# these should be rewritten by heirs----------------
#--------------------------------------------------------
#-------------- HEIR FUNCTIONS ----------------------------------

# needs to generate terrains, enemies, environmental hazards
# calculates possible spawn points
func _generate_stage():
	print('generation algorithm missing!')
