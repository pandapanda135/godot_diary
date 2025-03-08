extends button_interact

@onready var table_name_input:LineEdit = $"../TableName"

func _on_pressed() -> void:
	if table_name_input.text != "" and SqlSettings.BLOCKED_TABLE_NAMES.has(table_name_input.text) == false:
		Database.create_table(table_name_input.text)
	else:
		print(table_name_input.name,"table cannot be added due to issue with text")