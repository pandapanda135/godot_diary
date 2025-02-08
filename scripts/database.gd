extends Node

# maybe use later as used in demo
# signal output_received
# signal texture_received

var logs_verbosity = SQLite.VERY_VERBOSE

var db:SQLite = null

var db_name := "res://data"
#from demo keep json file for user select backup later
var packaged_db_name := "res://data_to_be_packaged"
var peristent_db_name := "user://database"
var json_name := "res://data/test_backup"

@onready var create_table_button:Button = $"../CreateTable"
@onready var add_table_button:Button = $"../AddTable"

@onready var main_text_input:TextEdit = $"../MainText"
@onready var optional_text_input:TextEdit = $"../OptionalText"

@onready var delete_data_button:Button = $"../DeleteData"
@onready var delete_id_input:TextEdit = $"../DeleteIdInput"

@onready var table_label:RichTextLabel = $"../TableLabel"

func _ready() -> void:
	create_table_button.pressed.connect(on_pressed)
	add_table_button.pressed.connect(on_pressed_add_table)
	delete_data_button.pressed.connect(on_pressed_delete_data)

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
	db.path = db_name
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
	db.path = db_name
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.insert_row("main", data)

	db.close_db()

func on_pressed_delete_data() -> void:
	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.delete_rows("main", "id = '" + delete_id_input.text + "'") #deletes row based on id inserted

	db.close_db()

func _process(delta):
	if FileAccess.file_exists(db_name) != true:
		db = SQLite.new()
		db.path = db_name
		db.verbosity_level = logs_verbosity
		db.open_db()


		var test:Array = db.select_rows("main","",["*"])
		print(test[0]["main_text"])
		var year_test:int = str_to_var(test[0]["year_made"])
		print(year_test)
		if year_test % 4 == 0 and year_test % 100 != 0 and year_test % 400 != 0: # check if year divisible by 4
			print("first if")
		elif year_test % 400 == 0:# check if year divisible by 400
			print("second if")
		else:
			print("not leap year")
		table_label.text = test[0]["main_text"]
	else:
		pass
