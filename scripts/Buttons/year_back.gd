extends button_interact

func _on_pressed() -> void:
	calendar_handler.current_year -= 1
	SignalManager.update_calendar.emit()
