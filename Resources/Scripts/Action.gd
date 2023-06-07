# contains information relevant to a specific unit action
class_name Action
extends Resource

@export var id = 'move' # used by units for execution
@export var button_icon : Texture2D
@export var type = Constants.ACTION_TYPES.MOVEMENT
@export var time = 1 # number of turns required to execute
@export var scope = [] # array of Vector2i
#------------------VARS USED CONDITIONALLY----------------
@export var aoe = []
@export var power = 0
