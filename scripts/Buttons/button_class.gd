class_name button_interact extends Button

@onready var calendar_handler:Control = $"/root/Main/CalendarHandler" #use root here as cant get relative to work

func _ready() -> void:
	self.connect("pressed",_on_pressed)

func _on_pressed() -> void:
	print("forgot to add pressed function on",self.name)
	pass