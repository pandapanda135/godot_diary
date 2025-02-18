extends Node

const STANDARD_VERBOSITY = SQLite.VERBOSE
const DB_PATH := "res://data"
const PACKAGED_DB_NAME := "res://data_to_be_packaged"
const SAVE_DB_PATH = "user://database" #use for build
const JSON_BACKUP := "res://data/database_backup"

var current_sqlite_id:int = 0 #? this will be used for changing between scenes