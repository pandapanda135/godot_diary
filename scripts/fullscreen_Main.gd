extends Control

@onready var db:Node = $DataBase

@onready var date_label:Label = $DateLabel

@onready var display_nodes:Control = $DisplayNodes
@onready var body_text_node:RichTextLabel = $DisplayNodes/BodyLabel
@onready var summary_node:RichTextLabel = $DisplayNodes/SummaryLabel

@onready var insert_nodes:Control = $InsertNodes
@onready var insert_body:TextEdit = $InsertNodes/BodyTextEdit
@onready var insert_summary:LineEdit = $InsertNodes/SummaryTextEdit

func _ready() -> void:
	if SqlSettings.current_sqlite_id == 0: # insert entry
		insert_nodes.visible = true
	else: # display entry
		var sqlite_data_array:Array[Dictionary] = db.get_text(SqlSettings.current_sqlite_id)
		var sqlite_data:Dictionary = sqlite_data_array[0]

		display_nodes.visible = true

		date_label.text = str(sqlite_data["year_made"], " ", sqlite_data["month_made"]," ", sqlite_data["day_made"])
		body_text_node.text = str(sqlite_data["main_text"])
		summary_node.text = str(sqlite_data["optional_summary"])