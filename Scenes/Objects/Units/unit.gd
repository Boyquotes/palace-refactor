extends Node2D

signal movement_finished

var grid_p : Vector2i
var unit_info : UnitInfo
var state = Constants.UNIT_STATES.IDLE

var _tween : Tween

# ------------EXTERNAL SHARED FUNCTIONS-----------------
func move_straight(new_p, speed, ease=Tween.EASE_OUT_IN, trans=Tween.TRANS_LINEAR):
	var dist = position.distance_to(new_p)
	var time = dist / speed
	_tween = get_tree().create_tween()
	_tween.tween_property(self, 'position', new_p, time).set_ease(ease).set_trans(trans)
	_tween.tween_callback(emit_signal.bind('movement_finished'))
	
# move in a 'jump' curve
func move_parabolic():
	pass

# target is an enemy, source is DamageSource
func attack(target, source : DamageSource):
	target.take_damage(source)
	
func take_damage(source):
	pass
# ------------HEIR FUNCTIONS---------------------

func available_actions():
	print('available actions not implemented!')
	
func get_action_range():
	print('get action range not implemented!')
	
func perform_action(_action, _grid_pos):
	print('perform action not implemented!')
