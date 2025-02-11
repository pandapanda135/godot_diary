extends Control

@onready var calendar_handler = $"/root/CalendarHandler"

var delay_time:float
var sqlite_id:int = 0
var date:int = -1
func _ready() -> void:
	self.scale = Vector2(0.1,0.1) # only animates if this value is higher than 1
	self.modulate.a = 0
	await get_tree().create_timer(delay_time).timeout
	var tween:Tween = self.create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.15)
	tween.parallel().tween_property(self, "scale",Vector2(1,1),0.25).set_trans(Tween.TRANS_QUAD)
	$Button.pressed.connect(_on_pressed)

var logs_verbosity = SqlSettings.STANDARD_VERBOSITY
var db_path: String = SqlSettings.DB_PATH #convert this to user so it saves in build
var db = SQLite.new()

func _on_pressed() -> void: #? maybe use this for fullscreen entry
	if sqlite_id != 0:
		db.path = db_path
		db.verbosity_level = logs_verbosity
		db.open_db()

		var sql_date_made:Array[Dictionary] = db.select_rows("main","id == %s" % str(sqlite_id),["main_text","optional_summary","id"])
		print(sql_date_made)
		db.close_db()
		SqlSettings.current_sqlite_id = sql_date_made[0]["id"]
		get_tree().change_scene_to_file("res://scene/entry_show.tscn")
	else:
		if date > Time.get_date_dict_from_system()["day"] and calendar_handler.current_year > Time.get_date_dict_from_system()["year"] or calendar_handler.current_month > Time.get_date_dict_from_system()["month"]: #? use for making sure cant create entry before day
			print("larger than current year or month or day") #TODO: fix this dont work
