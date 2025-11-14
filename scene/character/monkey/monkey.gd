extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -300.0

@export var max_speed: float = 250.0
@export var run_speed: float = 1500.0
@export var run_slowdown: float = 3000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * run_speed * delta
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, delta * run_slowdown)

	if velocity.x < -max_speed:
		velocity.x = -max_speed
	elif velocity.x > max_speed:
		velocity.x = max_speed

	move_and_slide()
