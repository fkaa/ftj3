extends CharacterBody2D
class_name Monkey

const JUMP_VELOCITY = -400.0
const WALL_JUMP_PUSH = 500
const MONKEY_HOHO_1 = preload("uid://brm58to3dtst7")
const MONKEY_FOOTSTEPS = preload("uid://crx6mobaoofwd")
const MONKEYOW = preload("uid://cxcqr5qo8pcow")

const FALL_SPEED = 450
const GRAVITY = 912
const SPEED = 256
const ACCEELLERATION = 2048

@export var max_speed: float = 250.0
@export var run_speed: float = 1500.0
@export var run_slowdown: float = 3000.0

@onready var visuals: Node2D = $visuals
@onready var cage: Node2D = $visuals/Cage
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var audio_manager: AudioManager

var run_timer = 0
var has_landed = true
var last_on_wall: bool = false
var walling: bool = false
var iframe_timer: float = 0

func _ready() -> void:
	$AnimatedSprite2D.play("run")
	audio_manager = AudioManager.new()
	add_child(audio_manager)


var last_dir: float = 0
var bananas: int = 0
var jump_cooldown = 0.0
var coyote = 0.0
const JUMP_COOLDOWN = 0.3
var sexing: bool = false
var let_go = false
signal break_free
const BANANA = preload("uid://dliekub8m1fdo")

func throw_banana(dir: Vector2 = Vector2.ZERO, audio: bool = true):
	var banana: Banana = BANANA.instantiate()
	banana.position = position
	banana.is_fresh = false
	if dir == Vector2.ZERO:
		banana.linear_velocity = Vector2(last_dir * 100.0, -100.0)
	else:
		banana.linear_velocity = dir
	get_parent().add_child(banana) 
	bananas -= 1
	if audio:
		audio_manager.play_audio(MONKEY_HOHO_1, 0.26)
		audio_manager.play_audio(load("res://asset/sfx/monkey/throw/throw.ogg"), -3.0, false, randf_range(0.5, 0.7))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("banana_drop"):
		var bodies = $BananaArea.get_overlapping_bodies()
		for body in bodies:
			if body is Zookeeper and iframe_timer <= 0:
				get_whipped(body)
				break

func jump():
	if is_on_wall_only() and abs(get_wall_normal().x) > 0.9:
		var normal = get_wall_normal()
		velocity.y = JUMP_VELOCITY
		velocity.x = normal.x * WALL_JUMP_PUSH
		jump_sound()
	else:
		if coyote > 0:
			jump_sound()
			velocity.y = JUMP_VELOCITY
			coyote = -1

func jump_sound():
	audio_manager.play_audio(MONKEY_HOHO_1, 0.26)
	audio_manager.play_audio_2d(MONKEY_FOOTSTEPS, self.position)
	audio_manager.play_audio_2d(load("res://asset/sfx/monkey/jump/jump-001.ogg"), self.position)


func _physics_process(delta: float) -> void:
	var on_wall = is_on_wall_only()
	if on_wall and not last_on_wall:
		jump_cooldown = JUMP_COOLDOWN
		walling = true
		
	if Input.is_action_just_released("ui_accept"):
		let_go = true
	if not is_on_floor():
		var speed = FALL_SPEED
		var grav = GRAVITY
		if let_go:
			speed = FALL_SPEED
			grav = GRAVITY * 2
		velocity.y = move_toward(velocity.y, speed, grav * delta)

	if is_on_floor() or is_on_wall():
		coyote = 0.3
		walling = false
	else:
		coyote -= delta

	iframe_timer -= delta
	
	if iframe_timer <= 0:
		animated_sprite_2d.modulate = Color.WHITE
	else:
		animated_sprite_2d.modulate = Color.from_rgba8(255, 255, 255, (int(iframe_timer * 8) % 2) * 255)

	
	var jump = Input.is_action_just_pressed("ui_accept")
	if jump:
		let_go = false
		jump()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction or jump:
		if cage:
			cage.reparent(get_parent())
			cage.break_cage()
			cage = null
			break_free.emit()
			animation_player.stop()
	
	if direction and not sexing:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEELLERATION * delta)
		if is_on_floor():
			$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction == 1
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEELLERATION * delta)
	
	if sexing:
		$AnimatedSprite2D.play("jump")
	elif !is_on_floor() and !is_on_wall():
		$AnimatedSprite2D.play("jump")
		has_landed = false
	elif is_on_wall_only():
		$AnimatedSprite2D.play("wall_jump")
	else:
		if has_landed == false:
			has_landed = true
			audio_manager.play_audio_2d(MONKEY_FOOTSTEPS, self.position)
		if abs(velocity.x) > 0:
			$AnimatedSprite2D.play("run")
			run_timer += 4 * delta
			if run_timer >= 1:
				run_timer = 0
				audio_manager.play_audio_2d(MONKEY_FOOTSTEPS, self.position)
		else:
			$AnimatedSprite2D.play("idle")



	last_on_wall = on_wall
	jump_cooldown -= delta
	move_and_slide()

const SLAP_2 = preload("uid://byltbcdi08upb")

func get_whipped(zookeeper: Zookeeper):
	sexing = true
	position.x = zookeeper.position.x + zookeeper.direction * 20
	$ AnimatedSprite2D.flip_h = zookeeper.direction == 1
	zookeeper.sex()
	$AnimatedSprite2D.play("jump")
	await get_tree().create_timer(2).timeout
	zookeeper.unsex()
	velocity.y -= 500
	for i in range(0,10):
		throw_banana(Vector2((i-5.0)/5.0*30, -150), false)
	audio_manager.play_audio_2d(SLAP_2, self.position)
	audio_manager.play_audio_2d(MONKEYOW, self.position)
	iframe_timer = 3.0
	sexing = false

func _on_banana_area_body_entered(body: Node2D) -> void:
	
	pass

var banana_pitch = 0
func _on_banana_area_area_entered(area: Area2D) -> void:
	if area is BananaPickup:# and body.is_fresh:
		bananas += 1
		area.queue_free()
		throw_banana()
		print(banana_pitch)
		if banana_pitch > 99 :
			banana_pitch = 0
		audio_manager.play_audio(load("res://asset/sfx/pickup.wav"), -6.0, false, 0.5 + banana_pitch / 100.0)
		banana_pitch += 1
