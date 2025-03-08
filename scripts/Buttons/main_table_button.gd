extends button_interact

@onready var table_drop_down:Control = $"../TableSelectButton"

func _on_pressed() -> void:
	print("WEE WOO LOOK AT THIS",table_drop_down.get_item_text(table_drop_down.selected))
	calendar_handler.modify_master_table_value(table_drop_down.get_item_text(table_drop_down.selected))
