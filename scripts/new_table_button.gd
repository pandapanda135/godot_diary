extends Button

@onready var table_name_input:LineEdit = $"../TableName"

func _on_pressed() -> void:
	if table_name_input.text != "":
		Database.create_table(table_name_input.text)
	else:
		print(table_name_input.name,"text is empty")