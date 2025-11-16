extends Node2D
class_name Section

@export var type_start: String
@export var type_end: String

var bounds: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounds = $TileMapLayer.get_used_rect().size * 16
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
