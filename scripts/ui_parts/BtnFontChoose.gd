extends Button

export (PackedScene) var packed_font_dialog : PackedScene

var font :DynamicFont= null setget _set_font

func _ready() -> void:
	connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
	var font_dialog := packed_font_dialog.instance() as FontSelectDialog
	get_tree().current_scene.add_child(font_dialog)
	font_dialog.connect("font_selected", self, "_set_font", [], CONNECT_DEFERRED)
	font_dialog.popup_centered_ratio()

func _set_font(n_font : DynamicFont) -> void:
	font = n_font
	if font != null:
		var tokens = font.resource_path.split("/")
		var n_text := (tokens[tokens.size()-1] as String) 
		self.text = n_text.substr(0, n_text.length()-5)
	else:
		self.text = "CHOOSE"
