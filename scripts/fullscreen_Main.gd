extends Control

@onready var db:Node = $DataBase

@onready var date_label:Label = $DateLabel

@onready var display_nodes:Control = $DisplayNodes
@onready var body_text_node:RichTextLabel = $DisplayNodes/BodyLabel
@onready var summary_node:Label = $DisplayNodes/SummaryLabel

@onready var insert_nodes:Control = $InsertNodes
@onready var insert_body:TextEdit = $InsertNodes/BodyTextEdit
@onready var insert_summary:LineEdit = $InsertNodes/SummaryTextEdit

@onready var back_button:Button = $BackButton
@onready var delete_button:Button = $DisplayNodes/DeleteButton
@onready var submit_button:Button = $InsertNodes/SubmitButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	submit_button.pressed.connect(_on_submit_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)

	if SqlSettings.current_sqlite_id == 0: # insert entry
		insert_nodes.visible = true
	else: # display entry
		var sqlite_data_array:Array[Dictionary] = db.get_text(SqlSettings.current_sqlite_id)
		var sqlite_data:Dictionary = sqlite_data_array[0]

		display_nodes.visible = true

		date_label.text = str(sqlite_data["year_made"], " ", sqlite_data["month_made"]," ", sqlite_data["day_made"])
		body_text_node.text = str(sqlite_data["main_text"])
		summary_node.text = str(sqlite_data["optional_summary"])

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")

func _on_submit_button_pressed() -> void:
	db.on_pressed_add_to_table(insert_body,insert_summary)

func _on_delete_button_pressed() -> void:
	var delete = db.delete_data(str(SqlSettings.current_sqlite_id))
	if delete == true:
		get_tree().change_scene_to_file("res://scene/main.tscn")
	else:
		printerr("issue with deleting file", "id: ", SqlSettings.current_sqlite_id)