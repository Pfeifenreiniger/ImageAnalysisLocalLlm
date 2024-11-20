extends Sprite2D


#-----------NODE REFERENCES-----------#

@onready var mouse_hover_detect_rect: ColorRect = $MouseHoverDetectRect as ColorRect
@onready var remove_texture_button: Button = $RemoveTextureButton as Button


#-----------PROPERTIES-----------#

var hover_over:bool
var start_position:Vector2 = Vector2.ZERO


#-----------METHODS-----------#

func _ready() -> void:
	texture_changed.connect(_on_texture_changed)
	mouse_hover_detect_rect.mouse_entered.connect(_on_mouse_hover_detect_rect_mouse_entered)
	mouse_hover_detect_rect.mouse_exited.connect(_on_mouse_hover_detect_rect_mouse_exited)
	remove_texture_button.pressed.connect(_on_remove_texture_button_pressed)
	
	start_position = position


func _process(_delta: float) -> void:
	_adjust_mouse_hover_detect_rect_size()
	_move()


func _get_sprite_size(with_scale:bool) -> Vector2:
	if texture:
		return texture.get_size() * scale if with_scale else texture.get_size()
	
	return Vector2.ZERO


func _adjust_scale_when_sprite_texture_is_too_large() -> void:
	
	var sprite_texture_size:Vector2 = _get_sprite_size(false)
	
	if sprite_texture_size.x >= 1500 || sprite_texture_size.y >= 1500:
		scale = Vector2(.25, .25)
		remove_texture_button.scale = Vector2(4., 4.)
	
	elif sprite_texture_size.x >= 1000 || sprite_texture_size.y >= 1000:
		scale = Vector2(.5, .5)
		remove_texture_button.scale = Vector2(2., 2.)
	
	else:
		scale = Vector2(1., 1.)
		remove_texture_button.scale = Vector2(1., 1.)


func _adjust_mouse_hover_detect_rect_size() -> void:
	mouse_hover_detect_rect.size = _get_sprite_size(false)


func _move() -> void:
	
	if !(hover_over && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	
	global_position = Globals.global_mouse_position - (_get_sprite_size(true) / 2)
	
	# Keep the Sprite2D within the Window boundaries
	position.x = 0 if position.x < 0 else position.x
	position.x = Globals.WINDOW_SIZE.x - _get_sprite_size(true).x if position.x + _get_sprite_size(true).x > Globals.WINDOW_SIZE.x else position.x
	position.y = 0 if position.y < 0 else position.y
	position.y = Globals.WINDOW_SIZE.y - _get_sprite_size(true).y if position.y + _get_sprite_size(true).y > Globals.WINDOW_SIZE.y else position.y


#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_texture_changed() -> void:
	_adjust_scale_when_sprite_texture_is_too_large()
	remove_texture_button.visible = true


func _on_mouse_hover_detect_rect_mouse_entered() -> void:
	hover_over = true
	var tween:Tween = create_tween()
	tween.tween_property(mouse_hover_detect_rect, "color:a", .3, .25).from(0.)


func _on_mouse_hover_detect_rect_mouse_exited() -> void:
	hover_over = false
	var tween:Tween = create_tween()
	tween.tween_property(mouse_hover_detect_rect, "color:a", 0., .25).from(.3)


func _on_remove_texture_button_pressed() -> void:
	texture = Texture.new()
	remove_texture_button.visible = false
	position = start_position

