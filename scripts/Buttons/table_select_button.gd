extends OptionButton

@onready var calendar_handler:Control = $"/root/CalendarHandler"

func _ready():
	_on_pressed()
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var current_index:int = self.get_selected_id()
	print("running on pressed")
	var current_tables:Array[Dictionary] = calendar_handler.return_all_tables()
	self.clear()
	for i:int in len(current_tables):
		if current_tables[i]["tbl_name"] != "sqlite_sequence":
			self.add_item(current_tables[i]["tbl_name"])
	self.selected = current_index