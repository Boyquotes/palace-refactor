extends Node2D

signal movement_finished

var grid_p : Vector2i
var enemy_info : EnemyInfo
var decision : EnemyDecision

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

func make_decision():
	print('make decision not implemented!')
	
func execute_decision():
	print('execute decision not implemented!')
