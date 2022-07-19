extends Control

onready var anim := $AnimationPlayer
onready var data_consumer := $DataConsumer
onready var background_colour := $ColorRect
onready var donor_credits_scroll := $CenterContainer/DonorCreditScroll
onready var toggle_options :ToggleOptions = $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/ToggleOptions"
onready var btn_bg_colour := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/HBoxContainer/BtnBackgroundColour"
onready var btn_font_colour := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/BtnFontColour"
onready var btn_heading_font_colour := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/HBoxContainer3/BtnHeadingFontColour"

onready var line_title_monthly := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/LineMonthly"
onready var line_title_one_off := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/LineOneOff"
onready var line_title_comms := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer3/LineComms"
onready var line_title_shop := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer4/LineShop"
onready var line_title_unassigned := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer5/LineUnassigned"
onready var spin_seconds_per_line := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/PlaybackSettings/HBoxContainer/SpinSecondsPerLine"
onready var btn_font_body := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/FontBody/BtnFontBody"
onready var btn_font_heading := $"SidePanel/MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer2/FontHeading/BtnFontHeading"

onready var font_noto_sans := preload("res://assets/font/noto/NotoSans.tres")

export var side_panel_visible := true

var font_colour : Color
var heading_font_colour := Color(-1, -1, -1)
var custom_font : Font = null
var custom_heading_font : Font = null


func _ready() -> void:
	anim.play("show_side_panel")
	font_colour = btn_font_colour.color

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
	_on_BtnRefresh_pressed()
	

func _on_background_colour_changed(color: Color) -> void:
	background_colour.color = color


func _on_font_colour_changed(color: Color) -> void:
	font_colour = color

func _on_heading_font_colour_changed(color: Color) -> void:
	heading_font_colour = color


func _on_BtnRefresh_pressed() -> void:
	var params := {}
	params.font_colour = font_colour
	if heading_font_colour.r >= 0:
		params.heading_font_colour = heading_font_colour
	params.seconds_per_line = spin_seconds_per_line.value
	# categories
	params.use_monthly = toggle_options.useMonthly
	params.use_one_off = toggle_options.useOneOff
	params.use_comms = toggle_options.useComms
	params.use_shop = toggle_options.useShop
	params.use_unassigned = toggle_options.useUnassigned
	params.titles = {
		"monthly" : line_title_monthly.text,
		"one_off" : line_title_one_off.text,
		"comms" : line_title_comms.text,
		"shop" : line_title_shop.text,
		"unassigned" : line_title_unassigned.text,
	}
	params.font_body = btn_font_body.font
	params.font_heading = btn_font_heading.font
	if params.font_body == null:
		params.font_body = font_noto_sans
	if params.font_heading == null:
		params.font_heading = font_noto_sans
	donor_credits_scroll.generate(params)

func _on_BtnPlay_pressed() -> void:
	anim.play_backwards("show_side_panel")
	anim.seek(-1.0, true)


func _on_Serializer_data_loaded() -> void:
	# refresh all the things that need it
	background_colour.color = btn_bg_colour.color
	font_colour = btn_font_colour.color
	heading_font_colour = btn_heading_font_colour.color
	_on_BtnRefresh_pressed() # regenerate view as well
