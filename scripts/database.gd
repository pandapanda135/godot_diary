extends Node

signal output_received
signal texture_received

var logs_verbosity = SQLite.VERBOSE

var db:SQLite = null

var db_name := "res://data"
var packaged_db_name := "res://data_to_be_packaged"
var peristent_db_name := "user://database"
var json_name := "res://data/test_backup"

@onready var create_table_button:Button = $"../CreateTable"
@onready var add_table_button:Button = $"../AddTable"
@onready var test_int_input:TextEdit = $"../TestInt"

@onready var delete_data_button:Button = $"../DeleteData"
@onready var delete_id_input:TextEdit = $"../DeleteIdInput"


func _ready() -> void:
	create_table_button.pressed.connect(on_pressed)
	add_table_button.pressed.connect(on_pressed_add_table)
	delete_data_button.pressed.connect(on_pressed_delete_data)

func on_pressed() -> void:
	var table:Dictionary = {
		"id": {"data_type": "int", "primary_key": true , "not_null" : true, "auto_increment": true},
		"test_int": {"data_type": "int"}
	}

	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = logs_verbosity
	db.open_db()

	db.create_table("main",table)

	db.close_db()

func on_pressed_add_table() -> void:
	var data = {
		"test_int" : int(test_int_input.text)
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