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


func return_all_tables() -> void:
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()
	var table_data:Dictionary

	var table_name = "name"
	var column_name = "sqlite_master"
	var select_type = "type='table'"
	# var query_result = db.query("SELECT "+ table_name +" FROM "+ column_name +" WHERE type='table'")
	var query_result_2 = db.select_rows(column_name,"SELECT "+ table_name +" FROM "+ column_name +" WHERE " + select_type,["*"]) #todo: find why this produces two queries
	print(query_result_2)
	db.close_db()

func _ready():
	return_all_tables()