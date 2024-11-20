extends Node2D

#-----------PROPERTIES-----------#

# screen and window sizes
var PRIMARY_MONITOR_ID:int = DisplayServer.get_primary_screen()
var WINDOW_SIZE:Vector2i = DisplayServer.window_get_size()
var MONITOR_SIZE:Vector2i = DisplayServer.screen_get_size(PRIMARY_MONITOR_ID)
var MONITOR_POSITION:Vector2i = DisplayServer.screen_get_position(PRIMARY_MONITOR_ID)

# mouse and window position
var global_mouse_position:Vector2
var window_position:Vector2i

#-----------METHODS-----------#

func _ready() -> void:
	global_mouse_position = get_global_mouse_position()
	
	print(DisplayServer.screen_get_size(0))


func _process(_delta: float) -> void:
	global_mouse_position = get_global_mouse_position()
	window_position = DisplayServer.window_get_position()
