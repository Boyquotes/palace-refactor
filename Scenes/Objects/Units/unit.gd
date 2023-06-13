extends Node2D

signal movement_finished

var active = true
var grid_p : Vector2i
var unit_info : UnitInfo
var state = Constants.UNIT_STATES.IDLE

var _tween : Tween

# ------------INTERNAL FUNCTIONS---------------------
func _set_active(value):
	pass

# ------------EXTERNAL SHARED FUNCTIONS-----------------
func set_grid_p(new_p):
	Global.grid_to_unit[grid_p] = null
	Global.grid_to_unit[new_p] = self
	grid_p = new_p

func move_straight(new_p, speed, ease=Tween.EASE_OUT_IN, trans=Tween.TRANS_LINEAR):
	if (new_p.x - position.x) < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	var dist = position.distance_to(new_p)
	var time = dist / speed
	_tween = get_tree().create_tween()
	_tween.tween_property(self, 'position', new_p, time).set_ease(ease).set_trans(trans)
	_tween.tween_callback(emit_signal.bind('movement_finished'))
	
# move in a 'jump' curve
# horizontal linear, vertical accelerated downwards
func move_parabolic(new_p, time):
	if (new_p.x - position.x) < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	_tween = get_tree().create_tween()
	var x_tween = get_tree().create_tween()
	_tween.tween_property(self, 'position:y', new_p.y - 10, time/2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, 'position:y', new_p.y, time/2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	x_tween.tween_property(self, 'position:x', new_p.x, time).set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(emit_signal.bind('movement_finished'))

# target is an enemy, source is DamageSource
func attack(target, source : DamageSource):
	target.take_damage(source)
	
func take_damage(source):
	pass
# ------------HEIR FUNCTIONS---------------------

# returns an array of actions that the player can take given current status
func available_actions():
	print('available actions not implemented!')
	
# needed for variable ranges. returns array of Vector2i
func get_action_range(_action):
	print('get action range not implemented!')
	
# base functionality for unit. moves, performs attacks, etc.
func perform_action(_action, _target_p):
	print('perform action not implemented!')
