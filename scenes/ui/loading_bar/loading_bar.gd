extends ProgressBar
class_name LoadingBar


#-----------METHODS-----------#

func _ready() -> void:
	value = 0.


func update_progress(progress:float) -> void:
	if progress < 0 || progress > 1:
		progress = 0.
	
	value = float(progress)
