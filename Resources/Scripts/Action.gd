# contains information relevant to a specific unit action
class_name Action
extends Resource

@export var id = 'move' # used by units for execution
@export var scope = [] # array of Vector2i
@export var type = Constants.ACTION_TYPES.MOVEMENT
@export var button_theme : Theme
@export var time = 1 # number of turns required to execute
#------------------VARS USED CONDITIONALLY----------------
@export var aoe = []
@export var power = 0
