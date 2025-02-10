extends Control

func _ready() -> void:
	self.scale = Vector2(0,0)
	self.modulate.a = 0
	var tween:Tween = self.create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.15)
	tween.parallel().tween_property(self, "scale",Vector2(1,1),0.25).set_trans(Tween.TRANS_QUAD)
