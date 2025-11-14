extends CharacterBody2D
class_name Monkey

const SPEED = 250.0
const JUMP_VELOCITY = -300.0

@export var max_speed: float = 250.0
@export var run_speed: float = 1500.0
@export var run_slowdown: float = 3000.0

@onready var cage: Node2D = $Cage

signal break_free

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	var jump = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	if jump:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction or jump:
		if cage:
			cage.reparent(get_parent())
			cage.break_cage()
			cage = null
			break_free.emit()
	
	if direction:
		velocity.x += direction * run_speed * delta
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, delta * run_slowdown)

	if velocity.x < -max_speed:
		velocity.x = -max_speed
	elif velocity.x > max_speed:
		velocity.x = max_speed

	move_and_slide()
