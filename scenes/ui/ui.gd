extends Control

#-----------NODE REFERENCES-----------#

@onready var file_dialog: FileDialog = $FileDialog as FileDialog
@onready var image_preview: Sprite2D = $ImagePreview as Sprite2D
@onready var user_prompt: TextEdit = $UserPrompt as TextEdit
@onready var response_field: TextEdit = $ResponseField as TextEdit
@onready var show_file_dialog_button: Button = $ShowFileDialogButton as Button
@onready var send_button: Button = $SendButton as Button
@onready var copy_button: Button = $ResponseField/CopyButton as Button
@onready var close_program_button: Button = $CloseProgramButton as Button
@onready var loading_bar: LoadingBar = $LoadingBar as LoadingBar


#-----------SCENE REFERENCES-----------#

@export var llm_request_manager:LlmRequestManager


#-----------PROPERTIES-----------#

var image_base64:String = ''

var loading_animation_tween:Tween


#-----------METHODS-----------#

func _ready() -> void:
	file_dialog.filters = ["*.png ; PNG Dateien", "*.jpg ; JPG Dateien"]
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.close_requested.connect(_on_file_dialog_close_requested)
	
	show_file_dialog_button.pressed.connect(_on_show_file_dialog_button_pressed)
	send_button.pressed.connect(_on_send_button_pressed)
	copy_button.pressed.connect(_on_copy_button_pressed)
	close_program_button.pressed.connect(_on_close_program_button_pressed)
	
	if llm_request_manager == null:
		printerr("KEIN LLM REQUEST MANAGER >:-O")
	else:
		llm_request_manager.got_llm_response.connect(_on_llm_request_manager_got_llm_response)
	
	loading_bar.visible = false


#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_file_selected(path: String) -> void:
	var image:Image = Image.new()
	if image.load(path) == OK:
		image_preview.texture = ImageTexture.create_from_image(image)
		
		var bytes:PackedByteArray
		
		if path.ends_with('.png'):
			bytes = image.save_png_to_buffer()
		
		elif path.ends_with('.jpg'):
			bytes = image.save_jpg_to_buffer()
		
		else:
			push_error("Unsupported image format")
			return
		
		image_base64 = Marshalls.raw_to_base64(bytes)
		
	else:
		printerr("Fehler beim Laden des Bildes:", path)
	
	show_file_dialog_button.text = "Open file-menu"


func _on_file_dialog_close_requested() -> void:
	show_file_dialog_button.text = "Open file-menu"


func _on_show_file_dialog_button_pressed() -> void:
	show_file_dialog_button.release_focus()
	if !file_dialog.visible:
		show_file_dialog_button.text = "Close file-menu"
		file_dialog.popup_centered()
	
	else:
		file_dialog.visible = false
		show_file_dialog_button.text = "Open file-menu"


func _on_send_button_pressed() -> void:
	send_button.release_focus()
	if llm_request_manager == null:
		return
	
	if image_base64.length() == 0:
		return
	
	if user_prompt.text.length() == 0:
		return
	
	llm_request_manager.dialogue_request(
		user_prompt.text,
		[image_base64]
	)
	
	send_button.disabled = true
	
	loading_bar.visible = true
	loading_animation_tween = create_tween()
	loading_animation_tween.set_loops(0)
	loading_animation_tween.tween_method(
		loading_bar.update_progress,
		0.0,
		1.0,
		1
	)


func _on_copy_button_pressed() -> void:
	copy_button.release_focus()
	var response_field_text:String = response_field.text
	if response_field_text.length() > 0:
		DisplayServer.clipboard_set(response_field_text)


func _on_close_program_button_pressed() -> void:
	get_tree().quit()


func _on_llm_request_manager_got_llm_response(response:String) -> void:
	response_field.text = response
	send_button.disabled = false
	loading_animation_tween.kill()
	loading_bar.visible = false
