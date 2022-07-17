extends VBoxContainer

export (NodePath) var data_consumer_path : NodePath
export (String) var segment_name := "People Preview"
export (Texture) var texture_visible : Texture
export (Texture) var texture_hidden : Texture

onready var data_consumer := get_node(data_consumer_path) as DataConsumer
onready var entries_root := $ScrollContainer/VBoxContainer
onready var btn_toggle_view :=$HBoxContainer/BtnToggleView
onready var anim := $AnimationPlayer

func _ready() -> void:
	$HBoxContainer/Label.text = segment_name
	_on_BtnToggleView_pressed()
	anim.play("Show")
	anim.seek(1,true)

func update_data() -> void:
	for c in entries_root.get_children():
		entries_root.remove_child(c)
		c.queue_free()
	var entries := data_consumer.get_all()
	for entry_name in entries.keys():
		var lbl := Label.new()
		lbl.text = entry_name
		lbl.align = Label.ALIGN_CENTER
		entries_root.add_child(lbl)


func _on_BtnToggleView_pressed() -> void:
	if $ScrollContainer.visible:
		anim.play_backwards("Show")
		btn_toggle_view.icon = texture_hidden
	else:
		anim.play("Show")
		btn_toggle_view.icon = texture_visible
