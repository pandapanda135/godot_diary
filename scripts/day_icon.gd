extends Control

var delay_time:float
var sqlite_id:int = 0

func _ready() -> void:
	self.scale = Vector2(0.1,0.1) # only animates if this value is higher than 1
	self.modulate.a = 0
	await get_tree().create_timer(delay_time).timeout
	var tween:Tween = self.create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.15)
	tween.parallel().tween_property(self, "scale",Vector2(1,1),0.25).set_trans(Tween.TRANS_QUAD)
	$Button.pressed.connect(_on_pressed)

var logs_verbosity = SQLite.VERY_VERBOSE
var db_name: String = "res://data" #convert this to user so it saves in build
var db = SQLite.new()

func _on_pressed() -> void:
	if $"EntryLabel".visible == true:
		db.path = db_name
		db.verbosity_level = logs_verbosity
		db.open_db()

		var sql_date_made:Array[Dictionary] = db.select_rows("main","id == %s" % str(sqlite_id),["main_text","optional_summary"])
		print(sql_date_made)
	else:
		print("asd")
