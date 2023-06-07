# inherited by actual stages
# inheritors have custom generation code, visuals, grid sizes, etc.
extends Node2D

signal position_select(grid_p)

const TILE_SCENE = preload("res://Scenes/System/tile.tscn")
const CELL_SIZE = Vector2i(25, 25)

enum MODES {SPAWN_SELECT, GRID_SELECT, ACTION_SELECT, WATCH_PHASE}
enum PHASES {PLAYER, ENEMY}

# ---------- INITIALIZATION VARS ------------------
@export var grid_size = Vector2i(7,4)
@export var difficulty = 0

# ------ VARIABLES FOR FUNCTIONALITY --------------
var current_mode = MODES.SPAWN_SELECT # affects what player input does
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
	
	var base_p = Vector2i(320 - (grid_size * CELL_SIZE / 2).x, 210 - (grid_size * CELL_SIZE).y)
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
			if tile.grid_p in Global.spawn_pts:
				emit_signal('position_select', tile.grid_p)
		MODES.WATCH_PHASE:
			pass

func _on_Action_Chosen(action):
	current_mode = MODES.ACTION_SELECT
	selected_action = action
	
	clear_tiles()
	
	var base = selected_unit.grid_p
	for v in action.scope:
		var p = base + v
	#	if selected_unit.flip_h: p += Vector2i(-v.x, v.y)
	#	else: p += v
		if Global.grid.is_within_bounds(p):
			Global.grid_to_tile[p].set_available(action.type)
	
func _on_End_Phase():
	pass

#=======================================================
#-------------------INTERNAL FUNCTIONS-------------------------
# add unit scenes to Units node, keep invisible
func _initialize_units():
	for unit_info in Global.units_info.values():
		if !unit_info:
			continue
		var unit = load('res://Scenes/Objects/Units/'+unit_info.unit_name+'.tscn').instantiate()
		unit.unit_info = unit_info
		unit.visible = false
		$Units.add_child(unit)
			

# buttons and status bars
func _initialize_UI():
	# buttons
	for unit in $Units.get_children():
		for action in unit.ACTIONS.values():
			var new_button = load('res://Scenes/UI/action_button.tscn').instantiate()
			new_button.action = action
			button_dict[action] = new_button
			
			match action.type:
				Constants.ACTION_TYPES.MOVEMENT:
					$Buttons/Move_Container.add_child(new_button)
				Constants.ACTION_TYPES.ATTACK:
					$Buttons/Attack_Container.add_child(new_button)
				Constants.ACTION_TYPES.SKILLS:
					$Buttons/Skill_Container.add_child(new_button)
			
	$Buttons.visible = false

# wait for player to click starting squares until all units spawned.
func _spawn_units():
	for unit in $Units.get_children():
		var grid_p = await position_select
		Global.spawn_pts.erase(grid_p)
		Global.grid_to_unit[grid_p] = unit
		unit.grid_p = grid_p
		unit.position = Global.grid_to_tile[grid_p].position
		unit.visible = true
		
	current_mode = MODES.GRID_SELECT

#================================================================
#---------------EXTERNAL FUNCTIONS-----------------------------
func select_unit(unit):
	$Buttons.visible = true
	selected_unit = unit
	
func deselect_unit():
	$Buttons.visible = false
	selected_unit = null
	
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
	
	# for testing
	Global.units_info[0] = UnitInfo.new(100)
	Global.spawn_pts = [Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3)]
