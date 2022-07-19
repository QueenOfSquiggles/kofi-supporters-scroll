extends Node
class_name DataConsumer

# Bit-Wise booleans, allows for any combination to be true
# 0000 -> no donation type, generally invalid
const BIT_DONATION_ONCE := 1 # 0001
const BIT_DONATION_MONTHLY := 2 # 0010
const BIT_DONATION_COMMISSION := 4 # 0100
const BIT_DONATION_SHOP := 8 # 1000

class Entry:
	var name : String
	var email : String
	var amount : float
	var donor_type : int
	var last_donation_date : String # IDK how else to convert it?

signal data_consume_complete

var data := {}

func consume_data_from(path : String) -> void:
	var file := File.new()
	data.clear() # erase old data
	if not file.open(path, File.READ) == OK:
		push_error("Failed to open file : %s" % path)
		return;
	var elements := file.get_csv_line() # consumes header entry
	while (elements.size() > 2):
		elements = file.get_csv_line()
		if elements.size() < 2:
			break
		var entry := Entry.new()
		entry.name = elements[0]
		entry.email = elements[1]
		var donor_bits := 0
		if (elements[2] as String).to_lower() == "true":
			donor_bits = donor_bits | BIT_DONATION_ONCE
		if (elements[3] as String).to_lower() == "true":
			donor_bits = donor_bits | BIT_DONATION_MONTHLY
		if (elements[4] as String).to_lower() == "true":
			donor_bits = donor_bits | BIT_DONATION_COMMISSION
		if (elements[5] as String).to_lower() == "true":
			donor_bits = donor_bits | BIT_DONATION_SHOP
		entry.donor_type = donor_bits
		entry.last_donation_date = elements[6]
		entry.amount = float(elements[7])

		data[entry.name] = entry # insert populated entry
	file.close()
	emit_signal("data_consume_complete")

func validate() -> bool:
	return not data.empty() # assume empty means problem

func get_all() -> Dictionary:
	return data.duplicate(true) # never give source dict

func get_one_off_donors() -> Dictionary:
	return match_donor_type(BIT_DONATION_ONCE)

func get_monthly_donors() -> Dictionary:
	return match_donor_type(BIT_DONATION_MONTHLY)

func get_commission_donors() -> Dictionary:
	return match_donor_type(BIT_DONATION_COMMISSION)

func get_shop_purchase_donors() -> Dictionary:
	return match_donor_type(BIT_DONATION_SHOP)

func match_donor_type(criteria : int) -> Dictionary:
	var result := {}
	for entry in data.values():
		var check_value :int = entry.donor_type & criteria
		if entry.donor_type & criteria != 0:
			print("Check Value: ", check_value)
			result[entry.name] = (entry as Entry)
	return result
