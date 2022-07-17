extends VBoxContainer

export (String) var button_text := "Choose A File"
export(Array, String) var file_filters := []

signal file_chosen(path)

func _ready() -> void:
	$BtnFileSelect.text = button_text

func _on_BtnFileSelect_pressed() -> void:
	var dialog := FileDialog.new()
	dialog.filters = file_filters
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.mode = FileDialog.MODE_OPEN_FILE
	get_tree().current_scene.add_child(dialog)
	dialog.connect("file_selected", self, "_file_selected", [dialog], CONNECT_ONESHOT | CONNECT_DEFERRED)
	dialog.popup_centered_ratio()

func _file_selected(path : String, dialog : FileDialog) -> void:
	$PanelContainer/ScrollContainer/CurrentFile.text = path
	emit_signal("file_chosen", path)
	dialog.queue_free()
