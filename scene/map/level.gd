extends Node2D

@export var monkey: Monkey
@onready var instructions: Node2D = $Instructions

var zookeepers: Array[Zookeeper] = []

func _ready() -> void:
	monkey.break_free.connect(_on_monkey_break_free)
	for c in get_children():
		if c is Zookeeper:
			zookeepers.push_back(c)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_monkey_break_free() -> void:
	instructions.visible = false
	for z in zookeepers:
		z.startle()
