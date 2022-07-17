extends Control

onready var anim := $AnimationPlayer
onready var data_consumer := $DataConsumer
onready var background_colour := $ColorRect
onready var donor_credits_scroll := $DonorCreditScroll

export var side_panel_visible := true

var font_colour : Color

func _ready() -> void:
	anim.play("show_side_panel")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_settings_panel"):
		if side_panel_visible:
			anim.play("show_side_panel", 0.1)
		else:
			anim.play_backwards("show_side_panel", 0.1)

func _on_FileSelectCSVData_file_chosen(path) -> void:
	data_consumer.consume_data_from(path)


func _on_DataConsumer_data_consume_complete() -> void:
	if not data_consumer.validate():
		var error := AcceptDialog.new()
		add_child(error)
		error.dialog_text = "Failed to load data from file"
		error.connect("hide", error, "queue_free", [], CONNECT_ONESHOT | CONNECT_DEFERRED)
		error.popup_centered_ratio(0.4)
		return
	
	donor_credits_scroll.generate({
		"font-colour" : font_colour,
		"catagories" : [
			# TODO fill this out
		]
	})
	




func _on_background_colour_changed(color: Color) -> void:
	background_colour.color = color


func _on_font_colour_changed(color: Color) -> void:
	font_colour = color
	push_error("NOT IMPLEMENTED!")


func _on_SpinBoxSecondsPerLine_value_changed(value: float) -> void:
	push_error("NOT IMPLEMENTED!")
