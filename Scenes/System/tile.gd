extends Node2D

const TILE_DEFAULT = preload("res://Assets/Sprites/Tiles/tile.png")
const TILE_HOVERED = preload("res://Assets/Sprites/Tiles/tile_hovered.png")
const TILE_SELECTED = preload("res://Assets/Sprites/Tiles/tile_selected.png")

var grid_p : Vector2i

var selected = false : set = _set_selected
var available = false

func _set_selected(value):
	selected = value
	if selected:
		$Main.texture = TILE_SELECTED
	else:
		$Main.texture = TILE_DEFAULT

func set_available(type):
	available = true
	match type:
		Constants.ACTION_TYPES.MOVEMENT:
			$Move_Sprite.visible = true
		Constants.ACTION_TYPES.ATTACK:
			$Attack_Sprite.visible = true
		Constants.ACTION_TYPES.SKILLS:
			pass

func clear():
	available = false
	$Move_Sprite.visible = false
	$Attack_Sprite.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				SignalBus.emit_signal('tile_selected', self)


func _on_area_2d_mouse_entered():
	if !selected:
		$Main.texture = TILE_HOVERED


func _on_area_2d_mouse_exited():
	if !selected:
		$Main.texture = TILE_DEFAULT
	
