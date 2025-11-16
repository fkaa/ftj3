extends Area2D
class_name BananaPickup
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite_2d.position.y = 5.0 * sin(position.x + 1.5 * Time.get_ticks_msec() * 0.001)
	pass
