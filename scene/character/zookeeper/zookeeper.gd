extends CharacterBody2D
class_name Zookeeper

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var target: Node2D
@onready var zzz_particles: CPUParticles2D = $zzzParticles
@onready var surprise_particles: CPUParticles2D = $surpriseParticles

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var run_timer = 0
var monkey_timer = 0
var lost_target = false

var sleeping = true

var audio_manager = AudioManager.new()

func _ready() -> void:
	add_child(audio_manager)
	if target:
		navigation_agent_2d.target_position = target.position
	animated_sprite_2d.play("sleep")
	zzz_particles.emitting = true
	pass
	
func startle():
	velocity.y = JUMP_VELOCITY
	zzz_particles.emitting = false
	surprise_particles.emitting = true
	sleeping = false
	animated_sprite_2d.play("walk")
	print("Awake")
	audio_manager.play_audio(load("res://asset/sfx/zoo_keeper/awake/awoken_keeper.tres"), 0.0)
	
	
func _physics_process(delta: float) -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position
		if not navigation_agent_2d.is_navigation_finished():
			navigation_agent_2d.velocity = velocity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if monkey_timer <= 0 and target and lost_target:
		target = null
		sleeping = true
		animated_sprite_2d.play("sleep")
		zzz_particles.emitting = true
		
		navigation_agent_2d.target_position = Vector2.ZERO

	monkey_timer -= delta
	
	if not sleeping:
		var target_position = navigation_agent_2d.get_next_path_position()
		var direction = global_position.direction_to(target_position)

		velocity.x = sign(direction.x) * 100.0
		
		run_timer += 1.6 * delta
		if run_timer >= 1:
			run_timer = 0
			audio_manager.play_audio_2d(load("res://asset/sfx/zoo_keeper/footsteps.tres"), global_position, -9.0)
		
		if direction.x > 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		velocity.x = 0
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


func _on_navigation_agent_2d_navigation_finished() -> void:
	pass # Replace with function body.


func _on_wake_area_body_entered(body: Node2D) -> void:
	if body is Monkey and not target:
		print(body)
		target = body
		startle()
		lost_target = false


func _on_wake_area_body_exited(body: Node2D) -> void:
	if body is Monkey and target:
		#target = null
		#sleeping = true
		monkey_timer = 3.0
		lost_target = true
		#navigation_agent_2d.target_position = Vector2.ZERO
