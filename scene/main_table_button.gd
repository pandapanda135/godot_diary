extends button_interact

@onready var table_drop_down:Control = $"/root/CalendarHandler/Buttons/TableController/TableSelectButton"

func _on_pressed() -> void:
	calendar_handler.modify_master_table_value(table_drop_down.get_item_text(table_drop_down.selected))
