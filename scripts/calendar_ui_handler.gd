extends Control

var date_dict = Time.get_date_dict_from_system()
#export for testing
@export var current_year:int = date_dict["year"] # these handle the calendar and are changed if the selected date on the calendar is
@export var current_month:int = date_dict["month"] # MAKE THIS ENUM FOR TIME ARTICLE GODOT DOCS
@export var current_date:int = date_dict["day"]