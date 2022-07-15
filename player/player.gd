extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var speed: float = 300.0
@export var jump: float = -400.0
@export var rotation_speed: float = 6
@export var faces: Array[Texture] = []
var _current_face: int
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		randomize()
		sprite.play()
		sprite.rotation += rotation_speed * delta * direction

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump

	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		randomize()
		sprite.play()
		sprite.rotation += rotation_speed * delta * direction
	else:
		sprite.rotation = 0
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	if(velocity == Vector2.ZERO):
		sprite.stop()
