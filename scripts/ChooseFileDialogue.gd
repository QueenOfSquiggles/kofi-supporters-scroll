extends FileDialog

signal valid_file_chosen(path)


func _on_BtnFileSelect_pressed() -> void:
	popup_centered_ratio()


func _on_FileDialog_file_selected(path: String) -> void:
	emit_signal("valid_file_chosen", path)
