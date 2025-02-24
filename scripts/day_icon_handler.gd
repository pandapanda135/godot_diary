extends Node

@onready var calendar_handler:Control = $"/root/CalendarHandler"
@onready var year_label:Control = $"/root/CalendarHandler/YearLabel"
@onready var month_label:Control = $"/root/CalendarHandler/MonthLabel"

var date_dict:Dictionary = Time.get_date_dict_from_system()

@export var current_month:int = date_dict["month"]

@onready var day_icon:PackedScene = preload("res://scene/day_icon.tscn")

var day_count:Dictionary = {
	1: 31,
	2: 28,
	3: 31,
	4: 30,
	5: 31,
	6: 30,
	7: 31,
	8: 31,
	9: 30,
	10: 31,
	11: 30,
	12: 31,
}

func _ready() -> void:
	SignalManager.connect("update_calendar",populate_container)
	populate_container()

func populate_container() -> void:
	date_dict = Time.get_date_dict_from_system()
	current_month = calendar_handler.current_month
	year_label.text = str(calendar_handler.current_year)
	month_label.text = str(current_month)

	for node:Node in self.get_children(): #handles removing children on change
		remove_child(node)
		node.call_deferred("free")

	if calendar_handler.current_month == Time.MONTH_FEBRUARY:
		if calendar_handler.current_year % 4 == 0 and calendar_handler.current_year % 100 != 0 and calendar_handler.current_year % 400 != 0: # check if year divisible by 4 not divisble by 100 or 400
			day_count[2] += 1
		elif calendar_handler.current_year % 400 == 0:# check if year divisible by 400
			day_count[2] += 1
		else:
			day_count[2] = 28
			print("not leap year")

	for date:int in day_count[current_month]: # handles spawning nodes
		date += 1 # starts at 0 so add 1
		var day_icon_node:Node = day_icon.instantiate()
		day_icon_node.get_node("DateLabel").text = str(date)
		day_icon_node.delay_time = float(date) / 100
		day_icon_node.date = date
		day_icon_node.name = "Day%s" % date
		if calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month == date_dict["month"] and date == date_dict["day"]: #TODO: improve this please maybe move all code to do with changing the month/year to another script
			day_icon_node.get_node("CurrentDayBackGround").visible = true
			print("setting %s as current date node" % day_icon_node.name)

		self.add_child(day_icon_node)

	hightlight_icon()

func hightlight_icon() -> void: # for finding if note exists on date
	var diary_data:Dictionary = calendar_handler.return_diary_data()
	print(diary_data.keys())
	for data:int in diary_data: # data = sqlite_id
		var nested_dict:Dictionary = diary_data[data]
		if nested_dict["year_made"] == str(calendar_handler.current_year) and nested_dict["month_made"] == str(calendar_handler.current_month) and self.get_node("Day%s" % nested_dict["day_made"]) != null:
			var node:Control = self.get_node("Day%s" % nested_dict["day_made"])
			node.sqlite_id = nested_dict["id"]
			node.get_node("EntryLabel").visible = true
