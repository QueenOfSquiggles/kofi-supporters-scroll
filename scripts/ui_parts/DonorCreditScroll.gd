extends ScrollContainer

export (NodePath) var data_consumer_path : NodePath

onready var data_consumer := get_node(data_consumer_path) as DataConsumer
onready var labels_root := $HBoxContainer/VBoxContainer
onready var tween :Tween = $Tween

var duration_seconds := 5.0
var seconds_per_line := 1.0

func generate(params : Dictionary) -> void:
	# generate the scroll data
	print("Generating with params: ", params)
	for c in labels_root.get_children():
		labels_root.remove_child(c)
		c.queue_free()

	seconds_per_line = params.seconds_per_line
	var all_entries := data_consumer.get_all()
	var temp := []
	var head_spacing := Control.new()
	
	# create head spacing
	head_spacing.rect_min_size.y = get_viewport_rect().size.y * 1.5 # add a little deadzone
	labels_root.add_child(head_spacing)
	tween.interpolate_property(self, "scroll_vertical", scroll_vertical, head_spacing.rect_min_size.y, 0.2)
	tween.start()
	
	# Monthly Donors
	if params.use_monthly:
		temp = data_consumer.get_monthly_donors().keys()
		for t in temp:
			all_entries.erase(t)
		_create_grouping_entry(params.titles.monthly, temp, params)
	
	# One-Off Donors
	if params.use_one_off:
		temp = data_consumer.get_one_off_donors().keys()
		for t in temp:
			all_entries.erase(t)
		_create_grouping_entry(params.titles.one_off, temp, params)
	
	# Commissions
	if params.use_comms:
		temp = data_consumer.get_commission_donors().keys()
		for t in temp:
			all_entries.erase(t)
		_create_grouping_entry(params.titles.comms, temp, params)
	
	# Shop Purchases
	if params.use_shop:
		temp = data_consumer.get_shop_purchase_donors().keys()
		for t in temp:
			all_entries.erase(t)
		_create_grouping_entry(params.titles.shop, temp, params)
	
	# All Else
	if params.use_unassigned:
		_create_grouping_entry(params.titles.unassigned, all_entries.keys(), params)
	var foot_spacing := Control.new()
	foot_spacing.rect_min_size.y = get_viewport_rect().size.y * 1.5 # add a little deadzone at the end as well
	labels_root.add_child(foot_spacing)


func play(_reset = true) -> void:
	if (labels_root.get_child_count() <= 0): return
	tween.remove_all()
	var scroll_max :float= labels_root.rect_size.y
	var duration := float(labels_root.get_child_count() - 2) * seconds_per_line
	tween.interpolate_property(self, "scroll_vertical", 0, scroll_max, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.5)
	tween.start()


func _create_grouping_entry(title : String, entries : Array, params : Dictionary) -> void:
	if (entries.size() <= 0):
		# skip empty groups
		return
	var lbl_heading := Label.new()
	lbl_heading.text = title
	lbl_heading.align = Label.ALIGN_CENTER
	lbl_heading.set_indexed("custom_fonts/font", params.font_heading)
	if params.has("heading_font_colour"):
		lbl_heading.modulate = params.heading_font_colour
	else:
		lbl_heading.modulate = params.font_colour
	labels_root.add_child(lbl_heading)
	
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGN_CENTER
	for e in entries:
		var lbl := Label.new()
		lbl.text = e
		lbl.modulate = params.font_colour
		lbl.set_indexed("custom_fonts/font", params.font_body)
		hbox.add_child(lbl)
		if hbox.get_child_count() >= 7:
			labels_root.add_child(hbox)
			hbox = HBoxContainer.new()
			hbox.alignment = BoxContainer.ALIGN_CENTER
	if hbox.get_child_count() > 0:
		labels_root.add_child(hbox)
		
	var spacer := HSeparator.new()
	spacer.rect_min_size.y = 32
	labels_root.add_child(spacer)

func _on_BtnPlay_pressed() -> void:
	play()

func _on_BtnReset_pressed() -> void:
	tween.remove_all()
	tween.interpolate_property(self, "scroll_vertical", scroll_vertical, get_viewport_rect().size.y * 1.5, 0.2)
	tween.start()
