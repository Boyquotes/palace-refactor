extends "res://Scenes/Objects/Units/unit.gd"

const ACTIONS = {MOVE = preload("res://Resources/Actions/Hunter/hunter_move.tres"),
	JUMP = preload("res://Resources/Actions/Hunter/hunter_jump.tres"),
	ATTACK = preload("res://Resources/Actions/Hunter/hunter_attack.tres")}

func _ready():
	pass

# ------------HEIR FUNCTIONS---------------------

func available_actions():
	print('available actions not implemented!')
	
func get_action_range():
	print('get action range not implemented!')
	
func perform_action(_action, _grid_pos):
	print('perform action not implemented!')
