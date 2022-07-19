extends Control
class_name HideableElement
func set_visibility(visible:bool) -> void:
	self.visible = visible

func toggle_visibility() -> void:
	visible = not visible
