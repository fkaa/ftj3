extends CharacterBody2D
class_name Monkey

const SPEED = 250.0
const JUMP_VELOCITY = -300.0

@export var max_speed: float = 250.0
@export var run_speed: float = 1500.0
@export var run_slowdown: float = 3000.0

@onready var visuals: Node2D = $visuals
@onready var cage: Node2D = $visuals/Cage
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	$AnimatedSprite2D.play("run")


var last_dir: float = 0
var bananas: int = 0

signal break_free
const BANANA = preload("uid://dliekub8m1fdo")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("banana_drop"):
		if bananas > 0:
			var banana: Banana = BANANA.instantiate()
			banana.position = position
			banana.is_fresh = false
			banana.linear_velocity = Vector2(last_dir * 100.0, -100.0)
			get_parent().add_child(banana)
			bananas -= 1
			pass

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
		last_dir = sign(direction)
		if cage:
			cage.reparent(get_parent())
			cage.break_cage()
			cage = null
			break_free.emit()
			animation_player.stop()
	
	
	if direction:
		velocity.x = direction * run_speed * 0.3
		print(direction)
		if is_on_floor():
			$AnimatedSprite2D.play("run")
		if direction == 1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, delta * run_slowdown)
	
	if !is_on_floor():
		$AnimatedSprite2D.play("jump")
	else:
		if abs(velocity.x) > 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	if velocity.x < -max_speed:
		velocity.x = -max_speed
	elif velocity.x > max_speed:
		velocity.x = max_speed

	move_and_slide()


func _on_banana_area_body_entered(body: Node2D) -> void:
	if body is Banana and body.is_fresh:
		bananas += 1
		body.queue_free()
