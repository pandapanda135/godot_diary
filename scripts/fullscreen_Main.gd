extends Control

@onready var db:Node = $DataBase

@onready var date_label:Label = $DateLabel
@onready var body_text_node:RichTextLabel = $BodyTextEdit
@onready var summary_node:RichTextLabel = $SummaryTextEdit

func _ready() -> void:
	var sqlite_data_array:Array[Dictionary] = db.get_text(SqlSettings.current_sqlite_id)
	var sqlite_data = sqlite_data_array[0]

	date_label.text = str(sqlite_data["year_made"], " ", sqlite_data["month_made"]," ", sqlite_data["day_made"])
	body_text_node.text = str(sqlite_data["main_text"])
	summary_node.text = str(sqlite_data["optional_summary"])
