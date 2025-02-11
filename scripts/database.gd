extends Node

# maybe use later as used in demo
# signal output_received
# signal texture_received

#? maybe make a singleton to keep sqlite settings in as right now its a mess

var logs_verbosity = SqlSettings.STANDARD_VERBOSITY

var db:SQLite = null

var db_path := SqlSettings.DB_PATH
#from demo keep json file for user select backup later
var packaged_db_path := SqlSettings.PACKAGED_DB_NAME
var peristent_db_path := SqlSettings.SAVE_DB_PATH #use for build
var json_name := SqlSettings.JSON_BACKUP

@onready var create_table_button:Button = $"../CreateTable"
@onready var add_table_button:Button = $"../AddTable"

@onready var main_text_input:TextEdit = $"../MainText"
@onready var optional_text_input:TextEdit = $"../OptionalText"

@onready var delete_data_button:Button = $"../DeleteData"
@onready var delete_id_input:TextEdit = $"../DeleteIdInput"

@onready var table_label:RichTextLabel = $"../TableLabel"

func _ready() -> void:
	pass
	# create_table_button.pressed.connect(on_pressed)
	# add_table_button.pressed.connect(on_pressed_add_table)
	# delete_data_button.pressed.connect(on_pressed_delete_data)

func on_pressed() -> void:
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

	db.create_table("main",table)

	db.close_db()

func on_pressed_add_table() -> void:
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

	db.insert_row("main", data)

	db.close_db()

func on_pressed_delete_data() -> void:
	db = SQLite.new()
	db.path = db_path
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.delete_rows("main", "id = '" + delete_id_input.text + "'") #deletes row based on id inserted

	db.close_db()
