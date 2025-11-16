extends CharacterBody2D
class_name Zookeeper

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@export var target: Node2D
@onready var zzz_particles: CPUParticles2D = $zzzParticles
@onready var surprise_particles: CPUParticles2D = $surpriseParticles

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var run_timer = 0
var monkey_timer = 0
var lost_target = false

var sleeping = false
var immune_timer: float = 30

var audio_manager = AudioManager.new()

func _ready() -> void:
	add_child(audio_manager)
	#if target:
	#	navigation_agent_2d.target_position = target.position
	#animated_sprite_2d.play("sleep")
	zzz_particles.emitting = false
	pass

func is_immune() -> bool:
	return immune_timer <= 0

func sex():
	sleeping = true
	animated_sprite_2d.play("sleep")

func unsex():
	$AnimatedSprite2D.modulate = Color.CORAL
	sleeping = false
	# animated_sprite_2d.play("walk")
	audio_manager.play_audio(load("res://asset/sfx/zoo_keeper/awake/awoken_keeper.tres"), 0.0)
	$CPUParticles2D.emitting = true

func startle():
	velocity.y = JUMP_VELOCITY
	zzz_particles.emitting = false
	surprise_particles.emitting = true
	sleeping = false
	animated_sprite_2d.play("walk")
	print("Awake")
	#audio_manager.play_audio(load("res://asset/sfx/zoo_keeper/awake/awoken_keeper.tres"), 0.0)
	
	
var direction: float = -1
func _physics_process(delta: float) -> void:
	if not is_on_floor() or is_on_wall():
		direction = -direction
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not sleeping:
		velocity.x = direction * SPEED
		run_timer += 1.6 * delta
		if run_timer >= 1:
			run_timer = 0
			audio_manager.play_audio_2d(load("res://asset/sfx/zoo_keeper/footsteps.tres"), global_position, -9.0)
		
		if direction > 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		velocity.x = 0
	
	move_and_slide()
		


func _on_navigation_agent_2d_navigation_finished() -> void:
	pass # Replace with function body.


func _on_wake_area_body_entered(body: Node2D) -> void:
	pass
	#if body is Monkey and not target:
		#print(body)
		#target = body
		#startle()
		#lost_target = false


func _on_wake_area_body_exited(body: Node2D) -> void:
	pass
	#if body is Monkey and target:
		##target = null
		##sleeping = true
		#monkey_timer = 3.0
		#lost_target = true
		##navigation_agent_2d.target_position = Vector2.ZERO


func _on_animated_sprite_2d_frame_changed() -> void:
	pass # Replace with function body.
	if sleeping:
		audio_manager.play_audio(load("res://asset/sfx/zoo_keeper/awake/awoken_keeper.tres"), 0.0)
