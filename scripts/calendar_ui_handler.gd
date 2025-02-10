extends Control

var date_dict:Dictionary = Time.get_date_dict_from_system()
#export for testing
@export var current_year:int = date_dict["year"] # these handle the calendar and are changed if the selected date on the calendar is
@export var current_month:int = date_dict["month"] # MAKE THIS ENUM FOR TIME ARTICLE GODOT DOCS
@export var current_date:int = date_dict["day"]

var logs_verbosity = SQLite.QUIET
var db_name: String = "res://data" #convert this to user so it saves in build
var db = SQLite.new()

func return_diary_data() -> Dictionary:
	db.path = db_name
	db.verbosity_level = logs_verbosity
	db.open_db()
	var diary_data:Dictionary

	# handles getting all data in main table
	var sql_date_made:Array[Dictionary] = db.select_rows("main","",["id","year_made","month_made","day_made"])
	for data:Dictionary in sql_date_made:
		if diary_data.find_key(data["id"]) == null: # if doesnt exist
			print("first if ", data)
			diary_data[data["id"]] = data
		else:
			printerr(data," already exists")
	db.close_db()
	return diary_data