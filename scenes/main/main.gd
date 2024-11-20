extends Control


#-----------NODE REFERENCES-----------#

@onready var window_grabber: Sprite2D = $WindowGrabber as Sprite2D
@onready var mouse_over_detect_rect: ColorRect = $WindowGrabber/MouseOverDetectRect as ColorRect


#-----------PROPERTIES-----------#

var mouse_hover_over_detect_rect:bool


#-----------METHODS-----------#

func _ready() -> void:
	mouse_over_detect_rect.mouse_entered.connect(_on_mouse_over_detect_rect_mouse_entered)
	mouse_over_detect_rect.mouse_exited.connect(_on_mouse_over_detect_rect_mouse_exited)
	_init_window_position_to_primary_monitor_center()


func _process(_delta: float) -> void:
	_move_window()
	
	# mouse hover over grabber but do not click it
	if (mouse_hover_over_detect_rect && !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		window_grabber.modulate = '#CEE2E1'


func _init_window_position_to_primary_monitor_center() -> void:
	var window_position:Vector2i = Globals.MONITOR_POSITION + (Globals.MONITOR_SIZE - Globals.WINDOW_SIZE) / 2
	DisplayServer.window_set_position(window_position)


func _move_window() -> void:
	
	# mouse do not hover over grabber and do not click it
	if !(mouse_hover_over_detect_rect && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	
	window_grabber.modulate = '#A02C79'
	
	var mouse_position:Vector2i = Vector2i(Globals.global_mouse_position.x, Globals.global_mouse_position.y) + Globals.window_position
	var mouse_position_offset:Vector2i = Vector2i(Globals.WINDOW_SIZE.x / 70, Globals.WINDOW_SIZE.y / 140)
	
	DisplayServer.window_set_position(
		mouse_position - mouse_position_offset
	)


#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_mouse_over_detect_rect_mouse_entered() -> void:
	mouse_hover_over_detect_rect = true
	window_grabber.modulate = '#CEE2E1'


func _on_mouse_over_detect_rect_mouse_exited() -> void:
	mouse_hover_over_detect_rect = false
	window_grabber.modulate = '#E264B3'
