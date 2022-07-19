extends HideableElement
class_name ToggleOptions

var useOneOff := false
var useMonthly := false
var useComms := false
var useShop := false
var useUnassigned := false

onready var toggle_one_off : CheckBox = $UseCategoryOneOff
onready var toggle_monthly : CheckBox = $UseCategoryMonthly
onready var toggle_comms : CheckBox = $UseCategoryComms
onready var toggle_shop : CheckBox = $UseCategoryShop
onready var toggle_unassigned : CheckBox = $UseCategoryUnassigned

func _ready() -> void:
	useOneOff = toggle_one_off.pressed
	useMonthly = toggle_monthly.pressed
	useComms = toggle_comms.pressed
	useShop = toggle_shop.pressed
	useUnassigned = toggle_unassigned.pressed

func _on_UseCategoryOneOff_toggled(button_pressed: bool) -> void:
	useOneOff = button_pressed

func _on_UseCategoryMonthly_toggled(button_pressed: bool) -> void:
	useMonthly = button_pressed

func _on_UseCategoryComms_toggled(button_pressed: bool) -> void:
	useComms = button_pressed

func _on_UseCategoryShop_toggled(button_pressed: bool) -> void:
	useShop = button_pressed

func _on_UseCategoryUnassigned_toggled(button_pressed: bool) -> void:
	useUnassigned = button_pressed
