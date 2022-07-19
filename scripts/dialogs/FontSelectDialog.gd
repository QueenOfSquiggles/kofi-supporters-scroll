extends WindowDialog
class_name FontSelectDialog

export (NodePath) var options_root_path : NodePath

onready var options_root := get_node(options_root_path) as Control

signal font_selected(font)

func _ready() -> void:
	for c in options_root.get_children():
		var btn := (c as Button)
		btn.connect("pressed", self, "_assign_font", [btn.get_indexed("custom_fonts/font")])

func _assign_font(font : DynamicFont) -> void:
	print("Font Selected: ", font.resource_path, " / ", font)
	emit_signal("font_selected", font)
	self.hide()
