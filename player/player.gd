extends CharacterBody2D

@export var face_change_timer: Timer
@export var sprite: Sprite2D
@export var speed: float = 300.0
@export var jump: float = -400.0
@export var rotation_speed: float = 6
@export var faces: Array[Texture] = []
@export var limit: int = 0
var _current_face: int
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.rotation += rotation_speed * delta * direction

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump

	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		sprite.rotation += rotation_speed * delta * direction
	else:
		sprite.rotation = 0
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _change_face() -> void:
	_current_face = randi() % (faces.size() - limit)
	sprite.texture = faces[_current_face]

func _on_face_change_timer_timeout():
	_change_face()


func _on_battle_zone_body_entered(body):
	if body is Enemy:
		body.direction = 0
		body.timer.stop()
		face_change_timer.stop()
		print("do fight")
