extends Control

var date_dict:Dictionary = Time.get_date_dict_from_system()
#export for testing
@export var current_year:int = date_dict["year"] # these handle the calendar and are changed if the selected date on the calendar is
@export var current_month:int = date_dict["month"]
@export var current_date:int = date_dict["day"]
@export var current_weekday:int = date_dict["weekday"]

var current_day_dict:Dictionary[String,int] = {
	"year":current_year,
	"month":current_month,
	"day":current_date,
	"weekday":current_weekday,
}

#YYYY-MM-DDTHH:MM:SS
var iso_string_format:String = "{YYYY}-{MM}-{DD}T{HH}:{MI}:{SS}"

var logs_verbosity = SqlSettings.STANDARD_VERBOSITY
var db_path: String = SqlSettings.SAVE_DB_PATH #convert this to user so it saves in build
var db:SQLite = SQLite.new()

func _ready() -> void:
	modify_master_table_row() # shouldnt overwrite value as default checks it doesnt exist I believe

func return_diary_data() -> Dictionary:
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()
	var diary_data:Dictionary

	# handles getting all data in main table
	var sql_date_made:Array[Dictionary] = db.select_rows("%s" % SqlSettings.current_table,"",["id","year_made","month_made","day_made"])
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

func modify_master_table_row() -> void:
	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	var new_row:Dictionary = {
		"default_table": {"data_type": "text","not_null": true,"default": "main"},
	}

	db.create_table("user_config",new_row)
	db.close_db()

func modify_master_table_value(inserted_table:String) -> void:
	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	var data:Dictionary = {
		"default_table": inserted_table
	}

	var last_value:Array[Dictionary] = db.select_rows("user_config","",["default_table"])
	print("Last Value",last_value)
	if inserted_table != "" and last_value != []: # fix issue with not being filled
		db.update_rows("user_config","default_table = '%s'" % last_value[0]["default_table"], data) # uses last value of column as otherwise dont work
	else:
		db.insert_row("user_config",{"default_table":"main"})
	db.close_db()

func update_day_dict() -> Dictionary[String,int]: # gets updated for day icon highlight if current day
	current_day_dict = {
	"year":current_year,
	"month":current_month,
	"day":current_date,
	"weekday":current_weekday,
}
	return current_day_dict

func datetime_string_formatter(year:int,month:int,day:int) -> String:
	return iso_string_format.format({"YYYY":str(year),"MM":str(month),"DD":str(day),"HH":str(0),"MI":str(0),"SS":str(01)})