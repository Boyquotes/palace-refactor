extends Button

var action : Action

func _ready():
	match action.type:
		Constants.ACTION_TYPES.MOVEMENT:
			theme = load("res://Resources/Buttons/move_button_theme.tres")
		Constants.ACTION_TYPES.ATTACK:
			theme = load("res://Resources/Buttons/attack_button_theme.tres")
		Constants.ACTION_TYPES.SKILLS:
			theme = load("res://Resources/Buttons/skill_button_theme.tres")
			
	icon = action.button_icon

func _on_toggled(_button_pressed):
	if _button_pressed:
		SignalBus.emit_signal('action_chosen', action)
	else:
		pass
