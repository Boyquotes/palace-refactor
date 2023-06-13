extends "res://Scenes/Objects/Units/unit.gd"

const ACTIONS = {MOVE = preload("res://Resources/Actions/Hunter/hunter_move.tres"),
	JUMP = preload("res://Resources/Actions/Hunter/hunter_jump.tres"),
	ATTACK = preload("res://Resources/Actions/Hunter/hunter_attack.tres")}

func _ready():
	pass

# ------------HEIR FUNCTIONS---------------------

func available_actions():
	print('available actions not implemented!')
	
func get_action_range(action):
	print('get action range not implemented!')
	
func perform_action(action, target_p):
	match action:
		ACTIONS.MOVE:
			move_straight(Global.grid_to_tile[target_p].position, 50, Tween.EASE_IN_OUT, Tween.TRANS_QUAD)
			set_grid_p(target_p)
			
		ACTIONS.JUMP:
			move_parabolic(Global.grid_to_tile[target_p].position, 1.0)
			set_grid_p(target_p)
		ACTIONS.ATTACK:
			print('attack! ' + str(target_p))
			
	await movement_finished
	self.active = false
	await get_tree().create_timer(0.2).timeout
	SignalBus.emit_signal('end_turn')
