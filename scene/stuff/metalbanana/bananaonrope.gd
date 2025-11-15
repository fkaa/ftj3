@tool
extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var metal_banana: MetalBanana = $MetalBanana

@export var banana_offset: Vector2 = Vector2(5.0, 20.0):
	set(val):
		if metal_banana:
			metal_banana.position = banana_offset
		banana_offset = val
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if metal_banana:
		metal_banana.position = banana_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = (sin(Time.get_ticks_msec()/1000.0)+0.35)
	var node: Node2D = metal_banana
	if node:
		line_2d.points[1] = node.position
	pass
