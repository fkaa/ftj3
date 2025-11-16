extends Control

var score: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_tween().tween_property($Sprite2D, "scale", Vector2(4.135, 4.135), 15.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%Label.text = "you earned %d science points" % score
	pass


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
