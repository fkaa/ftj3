extends Node2D

@export var monkey: Monkey
@onready var instructions: Node2D = $Instructions
@onready var camera_2d: Camera2D = $Camera2D
@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D
@onready var sections_nodes: Node2D = $SectionsNodes

var zookeepers: Array[Zookeeper] = []
var started = false
var section_map: Dictionary[String, Array] = {
	"start": [preload("res://scene/map/sections/start.tscn")],
	"open": [
		preload("res://scene/map/sections/a.tscn"),
		#preload("res://scene/map/sections/b.tscn"),
		#preload("res://scene/map/sections/c.tscn"),
		#preload("res://scene/map/sections/d.tscn"),
		#preload("res://scene/map/sections/e.tscn"),
	],
}

var sections: Array[Node2D] = []

func _ready() -> void:
	#var start = section_map["start"][0].instantiate()
	#var first = section_map["open"][0].instantiate()
	#sections_nodes.add_child(start)
	#sections_nodes.add_child(first)
	#first.position.y -= start.bounds.y

	navigation_region_2d.bake_navigation_polygon(true)
	#sections.push_back(start)
	#sections.push_back(first)
	
	monkey.break_free.connect(_on_monkey_break_free)
	for c in get_children():
		if c is Zookeeper:
			zookeepers.push_back(c)
	pass # Replace with function body.
const ENDSCREEN = preload("uid://dh1u3e7nron4v")

func finish_game():
	started = false
	timeleft = 0

	var s = ENDSCREEN.instantiate()
	s.score = monkey.science
	add_child(s)
	for z in zookeepers:
		z.queue_free()
	monkey.queue_free()
	pass

var timeleft = 200.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started:
		timeleft -= delta
	if timeleft <= 0 and started:
		finish_game()
	if started:
		%ScienceLabel.text = "%d" % monkey.science
		var minutes = floor(timeleft / 60)
		var seconds = floor(int(timeleft) % 60)
		%TimeLabel.text = "%dm %ds" % [minutes, seconds]
	pass

func add_new_section(last_section: Node2D):
	var sections_scenes: Array = section_map[last_section.type_end]
	var section: PackedScene = sections_scenes.pick_random()
	
	var scene: Section = section.instantiate()
	scene.position = last_section.position
	scene.position.y = last_section.position.y - last_section.bounds.y
	

	sections_nodes.add_child(scene)
	navigation_region_2d.position.y = monkey.position.x
	navigation_region_2d.bake_navigation_polygon(true)

	sections.push_back(scene)
	
func _on_monkey_break_free() -> void:
	started = true
	instructions.visible = false
	for z in zookeepers:
		z.startle()
