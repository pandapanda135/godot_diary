extends OptionButton

@onready var calendar_handler:Control = $"/root/CalendarHandler"
@onready var day_container:Control = $"/root/CalendarHandler/DayContainer"

static var default_table = SqliteSettings.return_default_table() # using class as static func

func _ready():
	print("LOOK AT THIS", SqlSettings.current_table)
	_on_pressed()
	self.pressed.connect(_on_pressed)
	self.item_selected.connect(_on_focused)
	if self.item_count <= 0:
		print("no tables")
	else:
		for count:int in self.item_count: # set table if not startup
			if self.get_item_text(count) == default_table:
				print(self.get_item_text(count)," is current table name")
				self.selected = count
				break
			else:
				print("not table name")

func _on_pressed() -> void:
	var current_index:int = self.get_selected_id()
	print("running on pressed")
	var current_tables:Array[Dictionary] = calendar_handler.return_all_tables()
	self.clear()
	for i:int in len(current_tables): # loop adds all tables
		if SqlSettings.BLOCKED_TABLE_NAMES.has(current_tables[i]["tbl_name"]) == false: # if is not blocked name
			self.add_item(current_tables[i]["tbl_name"])

	self.selected = current_index
	print("LOOK AT THIS ON_PRESSED",SqlSettings.current_table)

func _on_focused(index) -> void:
	self.selected = index
	SqlSettings.current_table = self.get_item_text(self.selected)
	day_container.populate_container()