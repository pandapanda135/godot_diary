extends Control

@onready var calendar_handler:Control = $"/root/Main/CalendarHandler"
@onready var new_button:Button = $HoverControl/HoverContainer/NewButton
@onready var view_button:Button  = $HoverControl/HoverContainer/ViewButton
@onready var back_ground:Panel = $CurrentDayBackGround

var delay_time:float
var sqlite_id:int = 0
var date:int = -1

func _ready() -> void:
	$Button.pressed.connect(_on_pressed)
	# new_button.pressed.connect(_on_new_pressed)
	# view_button.pressed.connect(_on_view_pressed)

	back_ground.scale = Vector2(0.1,0.1) # only animates if this value is higher than 1
	self.modulate.a = 0
	await get_tree().create_timer(delay_time).timeout
	var tween:Tween = self.create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.15)
	tween.parallel().tween_property(back_ground, "scale",Vector2(1,1),0.25).set_trans(Tween.TRANS_QUAD)

var logs_verbosity:int = SqlSettings.STANDARD_VERBOSITY
var db_path: String = SqlSettings.SAVE_DB_PATH #convert this to user so it saves in build
var db:SQLite = SQLite.new()

func _on_pressed() -> void: # used for fullscreen entry
	if sqlite_id != 0:
		db.path = db_path
		db.verbosity_level = logs_verbosity
		db.open_db()

		var sql_date_made:Array[Dictionary] = db.select_rows(SqlSettings.current_table,"id == %s" % str(sqlite_id),["main_text","optional_summary","id"])
		print("day icon",sql_date_made)
		db.close_db()
		SqlSettings.current_sqlite_id = sql_date_made[0]["id"]
		get_tree().change_scene_to_file("res://scene/entry_show.tscn")
	else:
		var date_dict:Dictionary = Time.get_date_dict_from_system()
		if calendar_handler.current_year > date_dict["year"]: # handles checking if pressed buttons date is lower than or higher than current day (pls refactor this someday)
			print("larger")
		elif calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month >= date_dict["month"] and date > date_dict["day"]:
			print("larger 2")
		elif calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month > date_dict["month"] and date <= date_dict["day"]:
			print("larger 3")

		if calendar_handler.current_year < date_dict["year"]:
			print("smaller")
		elif calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month <= date_dict["month"] and date < date_dict["day"]:
			print("smaller 2")
		elif calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month < date_dict["month"] and date >= date_dict["day"]:
			print("smaller 3")

		if calendar_handler.current_year == date_dict["year"] and calendar_handler.current_month == date_dict["month"] and date == date_dict["day"]:
			SqlSettings.current_sqlite_id = sqlite_id
			get_tree().change_scene_to_file("res://scene/entry_show.tscn")
