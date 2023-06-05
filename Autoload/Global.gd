extends Node

const SFX_SCENE = preload('res://Scenes/System/sfx.tscn')

# ---------- RUN INFO -----------------------
var units_info = {0: UnitInfo.new(100), 1: null, 2: null, 3: null} # saves unit info across stages
var money = 0

# ---------- GRID VARS --------------------
var spawn_pts = [] # filled by generation algorithm. offers possible starting squares.
var grid : Grid # grid for current stage
var grid_to_tile = {} # Vector2i -> tile
var grid_to_terrain = {} # Vector2i -> terrain
var grid_to_unit = {} # Vector2i -> unit
var grid_to_enemy = {} # Vector2i -> enemy
# ---------------------------------------------

# General sfx player
func play_sfx(path, _random=null, _range=null):
	var s = load('res://Assets/Sounds/SFX/' + path)
	var sfx = SFX_SCENE.instantiate()
	if _random:
		sfx.random = _random
	if _range:
		sfx.range = _range
	sfx.stream = s
	add_child(sfx)
