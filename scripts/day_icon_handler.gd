extends Node

@onready var calendar_handler:Control = $"/root/Main/CalendarHandler"
@onready var year_label:Control = $"/root/Main/CalendarHandler/YearLabel"
@onready var month_label:Control = $"/root/Main/CalendarHandler/MonthLabel"

var date_dict:Dictionary = Time.get_date_dict_from_system()
@export var current_month:int = date_dict["month"]

@onready var day_icon:PackedScene = preload("res://scene/day_icon.tscn")

var day_count:Dictionary[int,Dictionary] = {
	1: {"month_name":"January","day_amount":31,},
	2: {"month_name":"Febuary","day_amount":28,},
	3: {"month_name":"March","day_amount":31},
	4: {"month_name":"April","day_amount":30},
	5: {"month_name":"May","day_amount":31},
	6: {"month_name":"June","day_amount":30},
	7: {"month_name":"July","day_amount":31},
	8: {"month_name":"August","day_amount":31},
	9: {"month_name":"September","day_amount":30},
	10: {"month_name":"October","day_amount":31},
	11: {"month_name":"November","day_amount":30},
	12: {"month_name":"December","day_amount":31},
}

func _ready() -> void:
	SignalManager.connect("update_calendar",populate_container)
	populate_container()

func populate_container() -> void:
	var calendar_day_dict:Dictionary[String,int] = calendar_handler.update_day_dict()
	date_dict = Time.get_date_dict_from_system()
	current_month = calendar_handler.current_month
	year_label.text = str(calendar_handler.current_year)
	month_label.text = str(day_count[current_month]["month_name"])
	var previous_day_nodes:Array[Control]

	for node:Node in self.get_children(): #handles removing children on change
		remove_child(node)
		node.call_deferred("free")

	if calendar_handler.current_month == Time.MONTH_FEBRUARY:
		if calendar_handler.current_year % 4 == 0 and calendar_handler.current_year % 100 != 0 and calendar_handler.current_year % 400 != 0: # check if year divisible by 4 not divisble by 100 or 400
			day_count[2]["day_amount"] += 1
		elif calendar_handler.current_year % 400 == 0:# check if year divisible by 400
			day_count[2]["day_amount"] += 1
		else:
			day_count[2]["day_amount"] = 28
			print("not leap year")

	var datetime_string_first:Dictionary = get_selected_datetime(calendar_handler.datetime_string_formatter(calendar_day_dict["year"],calendar_day_dict["month"],1))
	var datetime_string_last:Dictionary = get_selected_datetime(calendar_handler.datetime_string_formatter(calendar_day_dict["year"],calendar_day_dict["month"],day_count[current_month]["day_amount"]))
	printerr(datetime_string_first, " || " ,datetime_string_last)
	var has_checked_last_month:bool = false
	for date:int in day_count[current_month]["day_amount"]: # handles spawning nodes
		date += 1 # starts at 0 so add 1
		printerr(date)
		var day_icon_node:Node = day_icon.instantiate()

		#Handles adding previous months days
		if datetime_string_first["weekday"] >= 1 and has_checked_last_month == false:
			has_checked_last_month = true
			date = day_count[current_month - 1]["day_amount"]
			for i:int in datetime_string_first["weekday"]:
				var day_icon_node_previous:Node = day_icon.instantiate()
				printerr(i," || ", datetime_string_first["weekday"], " || ",date)
				if i == 0:
					pass
				elif date - 1 == datetime_string_first["weekday"] - day_count[current_month - 1]["day_amount"]: # idk what this does tbh
					break
				else:
					date -= 1

				day_icon_node_previous.get_node("DateLabel").text = str(date)
				day_icon_node_previous.date = date
				day_icon_node_previous.name = "PreviousDay%s" % date

				self.add_child(day_icon_node_previous)
				previous_day_nodes.push_back(day_icon_node_previous) # must push back as reorder will not work
			date = 1
			# reorder nodes
			var current_node_index:int = 0
			for node:Control in previous_day_nodes:
				if node.date < day_count[current_month - 1]["day_amount"]:
					self.move_child(node,0)
					current_node_index += 1
				elif node.date == day_count[current_month - 1]["day_amount"]:
					self.move_child(node,current_node_index)
					current_node_index += 1

		print("got to line 80 ", date)


		#set appropriate variables
		day_icon_node.get_node("DateLabel").text = str(date)
		day_icon_node.delay_time = float(date) / 100
		day_icon_node.date = date
		day_icon_node.name = "Day%s" % date

		if calendar_day_dict == date_dict and calendar_handler.current_date == date: #TODO: Could probably improve this further but its good enough
			day_icon_node.get_node("CurrentDayBackGround").visible = true # set if current day
			print("setting %s as current date node" % day_icon_node.name)

		self.add_child(day_icon_node)

	highlight_icon()

func highlight_icon() -> void: # for finding if entry exists on date
	var diary_data:Dictionary = calendar_handler.return_diary_data()
	print(diary_data.keys())
	for data:int in diary_data: # data = sqlite_id
		var nested_dict:Dictionary = diary_data[data]
		if nested_dict["year_made"] == str(calendar_handler.current_year) and nested_dict["month_made"] == str(calendar_handler.current_month) and self.get_node("Day%s" % nested_dict["day_made"]) != null:
			var node:Control = self.get_node("Day%s" % nested_dict["day_made"])
			node.sqlite_id = nested_dict["id"]
			node.get_node("EntryLabel").visible = true

func get_selected_datetime(datetime_string:String) -> Dictionary:
	return Time.get_datetime_dict_from_datetime_string(datetime_string,true)
