extends Node

export (Array, NodePath) var serialized_nodes := []

signal data_loaded

func save_data() -> void:
	var chooser := FileDialog.new()
	get_tree().current_scene.add_child(chooser)
	chooser.access = FileDialog.ACCESS_FILESYSTEM
	chooser.filters = PoolStringArray(["*.json ; JSON Files"])
	chooser.mode = FileDialog.MODE_SAVE_FILE
	chooser.connect("file_selected", self, "_save_to_file", [chooser], CONNECT_DEFERRED)
	chooser.popup_centered_ratio(0.8)

func _save_to_file(path : String, chooser : FileDialog) -> void:
	chooser.queue_free()
	var file := File.new()
	if file.open(path, File.WRITE) == OK:
		var data := _get_data_from_elements()
		file.store_string(to_json(data))
		file.close()

func _get_data_from_elements() -> Dictionary:
	var data := {}
	for element in serialized_nodes:
		var node := get_node(element)
		data[element] = {}
		if "text" in node:
			data[element].text = node.text
		if "value" in node:
			data[element].value = node.value
		if "pressed" in node:
			data[element].pressed = node.pressed
		if "color" in node:
			data[element].color = (node.color as Color).to_html(false)
	return data

func load_data() -> void:
	var chooser := FileDialog.new()
	get_tree().current_scene.add_child(chooser)
	chooser.access = FileDialog.ACCESS_FILESYSTEM
	chooser.filters = PoolStringArray(["*.json ; JSON Files"])
	chooser.mode = FileDialog.MODE_OPEN_FILE
	chooser.connect("file_selected", self, "_load_from_file", [chooser], CONNECT_DEFERRED)
	chooser.popup_centered_ratio(0.8)

func _load_from_file(path : String, chooser : FileDialog) -> void:
	chooser.queue_free()
	var file := File.new()
	if file.open(path, File.READ) == OK:
		var file_data := parse_json(file.get_as_text()) as Dictionary
		_assign_data_to_elements(file_data)
		file.close()
		emit_signal("data_loaded")

func _assign_data_to_elements(data : Dictionary) -> void:
	for node_path in data.keys():
		var node := get_node(node_path)
		var node_settings := data[node_path] as Dictionary
		for key in node_settings.keys():
			var value = node_settings[key]
			if key == "color":
				var col := Color(value)
				node.color = col
			else:
				node.set_indexed(key, node_settings[key])
