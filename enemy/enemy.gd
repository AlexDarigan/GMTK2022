extends CharacterBody2D
class_name Enemy

@export var player: AnimationPlayer
@export var timer: Timer
@export var sprite: Sprite2D
@export var speed: float = 300.0
@export var jump: float = -400.0
@export var rotation_speed: float = 6
@export var faces: Array[Texture] = []
@export var limit: int = 0
var face: int = 0
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1



func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	sprite.rotation += rotation_speed * delta * direction
	
	if is_on_wall():
		direction = -direction

func _change_face() -> void:
	face = randi() % (faces.size() - limit)
	sprite.texture = faces[face]

func _on_face_change_timer_timeout():
	_change_face()

func die() -> void:
	player.play("Death")
	print("enemy died")
