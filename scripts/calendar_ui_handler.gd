extends Control

var date_dict:Dictionary = Time.get_date_dict_from_system()
#export for testing
@export var current_year:int = date_dict["year"] # these handle the calendar and are changed if the selected date on the calendar is
@export var current_month:int = date_dict["month"]
@export var current_date:int = date_dict["day"]

var logs_verbosity = SqlSettings.STANDARD_VERBOSITY
var db_path: String = SqlSettings.DB_PATH #convert this to user so it saves in build
var db:SQLite = SQLite.new()

func return_diary_data() -> Dictionary:
	db.path = db_path
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

func return_all_tables() -> Array[Dictionary]:
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	var column_name:String = "sqlite_master"
	var query_result:Array[Dictionary] = db.select_rows(column_name,"",["tbl_name"])
	db.close_db()
	return query_result
