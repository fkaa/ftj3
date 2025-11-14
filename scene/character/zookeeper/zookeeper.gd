extends CharacterBody2D
class_name Zookeeper

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var target: Node2D
@onready var zzz_particles: CPUParticles2D = $zzzParticles
@onready var surprise_particles: CPUParticles2D = $surpriseParticles


func _ready() -> void:
	navigation_agent_2d.target_position = target.position
	pass
	
func startle():
	velocity.y = JUMP_VELOCITY
	zzz_particles.emitting = false
	surprise_particles.emitting = true
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if navigation_agent_2d.is_navigation_finished():
		return
	
	navigation_agent_2d.velocity = velocity
	var target_position = navigation_agent_2d.get_next_path_position()

	# Add the gravity.

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	##var direction := position - target_position
	##if direction:
	##	velocity.x = direction * SPEED
	##else:
	##	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
