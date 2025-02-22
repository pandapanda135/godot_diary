extends OptionButton

@onready var calendar_handler:Control = $"/root/CalendarHandler"
@onready var day_container:Control = $"/root/CalendarHandler/DayContainer"

func _ready():
	print("LOOK AT THIS", SqlSettings.current_table)
	_on_pressed()
	self.pressed.connect(_on_pressed)
	self.item_selected.connect(_on_focused)
	if self.item_count <= 0:
		print("no tables")
	else:
		if SqlSettings.current_table != "": #TODO: will have to change when sqlite_config todo is done
			for count:int in self.item_count: # set table if not startup
				if self.get_item_text(count) == SqlSettings.current_table:
					print(self.get_item_text(count)," is current table name")
					self.selected = count
					break
				else:
					print("not table name")
		else:
			print("LOOK AT THIS FIRST ELSE")
			self.selected = 0
			SqlSettings.current_table = self.get_item_text(self.selected)

func _on_pressed() -> void:
	var current_index:int = self.get_selected_id()
	print("running on pressed")
	var current_tables:Array[Dictionary] = calendar_handler.return_all_tables()
	self.clear()
	for i:int in len(current_tables): # loop adds all tables
		if current_tables[i]["tbl_name"] != "sqlite_sequence":
			self.add_item(current_tables[i]["tbl_name"])

	self.selected = current_index
	print("LOOK AT THIS ON_PRESSED",SqlSettings.current_table)

func _on_focused(index) -> void:
	self.selected = index
	SqlSettings.current_table = self.get_item_text(self.selected)
	day_container.populate_container()