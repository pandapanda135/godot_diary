extends button_interact

func _on_pressed() -> void:
	if calendar_handler.current_month <= 1:
		calendar_handler.current_year -= 1
		calendar_handler.current_month = 12
	else:
		calendar_handler.current_month -= 1
	SignalManager.update_calendar.emit()
