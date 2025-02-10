extends Control

var delay_time:float

func _ready() -> void:
	self.scale = Vector2(0.1,0.1) # only animates if this value is higher than 1
	self.modulate.a = 0
	await get_tree().create_timer(delay_time).timeout
	var tween:Tween = self.create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.15)
	tween.parallel().tween_property(self, "scale",Vector2(1,1),0.25).set_trans(Tween.TRANS_QUAD)