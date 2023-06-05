extends Node

# System
signal end_phase
signal end_turn 

# Gameplay
signal tile_selected(tile) # emitted upon clicking on a tile
signal action_chosen(action) # emitted upon clicking on an action button
