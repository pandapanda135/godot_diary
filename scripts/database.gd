class_name Database extends Node

# maybe use later as used in demo
# signal output_received
# signal texture_received

#? maybe make a singleton to keep sqlite settings in as right now its a mess

static var logs_verbosity = SqlSettings.STANDARD_VERBOSITY

static var db:SQLite = null

static var db_path := SqlSettings.DB_PATH
#from demo keep json file for user select backup later
static var packaged_db_path := SqlSettings.PACKAGED_DB_NAME
static var peristent_db_path := SqlSettings.SAVE_DB_PATH #use for build
static var json_name := SqlSettings.JSON_BACKUP

@onready var create_table_button:Button = $"../CreateTable"
@onready var add_table_button:Button = $"../AddTable"

@onready var delete_data_button:Button = $"../DeleteData"
@onready var delete_id_input:TextEdit = $"../DeleteIdInput"

@onready var table_label:RichTextLabel = $"../TableLabel"

func _ready() -> void:
	pass
	# create_table_button.pressed.connect(on_pressed)
	# delete_data_button.pressed.connect(on_pressed_delete_data)

static func create_table(input_name:String = "main") -> void:
	var table:Dictionary = {
		"id": {"data_type": "int", "primary_key": true , "not_null" : true , "auto_increment": true},
		"main_text": {"data_type": "text","not_null": true},
		"optional_summary": {"data_type": "text"}, # make this a char later once figured out what to make the max char limit
		"year_made": {"data_type": "text","not_null": true},
		"month_made": {"data_type": "text","not_null": true},
		"day_made": {"data_type": "text","not_null": true},
		"time_made": {"data_type": "text","not_null": true}
	}

	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.create_table(input_name,table)

	db.close_db()

func on_pressed_add_to_table(main_text_input:TextEdit,optional_text_input:LineEdit) -> void:
	var date_dict:Dictionary = Time.get_date_dict_from_system()
	var data = {
		"main_text" : main_text_input.text,
		"optional_summary" : optional_text_input.text,
		"year_made" : date_dict["year"],
		"month_made" : date_dict["month"],
		"day_made" : date_dict["day"],
		"time_made" : Time.get_time_string_from_system()
	}

	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.insert_row("%s" % SqlSettings.current_table, data)

	db.close_db()

func delete_data(id) -> bool:
	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	if db.delete_rows("%s", "id = '" + id + "'" % SqlSettings.current_table) == true:
		db.delete_rows("%s", "id = '" + id + "'" % SqlSettings.current_table)
	else:
		return false
	db.close_db()
	return true

func get_text(sqlite_id) -> Array[Dictionary]:
		db = SQLite.new()
		db.path = db_path
		db.verbosity_level = logs_verbosity
		db.open_db()

		var sql_data:Array[Dictionary] = db.select_rows("%s" % SqlSettings.current_table,"id == %s" % str(sqlite_id),["*"])
		print(sql_data)
		db.close_db()
		return sql_data
