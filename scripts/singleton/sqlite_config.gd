extends Node
class_name SqliteSettings

const STANDARD_VERBOSITY = SQLite.VERBOSE
const DB_PATH := "res://data"
const PACKAGED_DB_NAME := "res://data_to_be_packaged"
const SAVE_DB_PATH = "user://database" #use for build
const JSON_BACKUP := "res://data/database_backup"

static var current_sqlite_id:int = 0 #? this will be used for changing between scenes
static var current_table:String = return_default_table()

static func return_default_table() -> String:
	var db = SQLite.new()
	db.path = DB_PATH
	db.verbosity_level = STANDARD_VERBOSITY
	db.open_db()


	var value:Array[Dictionary] = db.select_rows("user_config","",["default_table"])
	db.close_db()

	return value[0]["default_table"]
