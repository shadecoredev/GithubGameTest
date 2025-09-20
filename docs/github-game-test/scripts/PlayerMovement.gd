extends CharacterBody2D
class_name PlayerMovement

@export var speed : float = 100.0

signal movement_input_signal(vector : Vector2i)

var _movement_locked : bool = false

var _last_input_vector : Vector2i

func _physics_process(_delta):
	move_and_slide()

func _input(event : InputEvent) -> void:
	if _movement_locked:
		return
	
	if event.is_action("ui_left") or event.is_action("ui_right") or event.is_action("ui_up") or event.is_action("ui_down"):
		var vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var vector2i = Vector2i(
			round(vector.x),
			round(vector.y)
		)
		if vector2i != _last_input_vector:
			_last_input_vector = vector2i
			_handle_movement_input(
				_last_input_vector
			)

func _handle_movement_input(vector : Vector2i) -> void:
	movement_input_signal.emit(vector)
	apply_movement(vector)

func apply_movement(vector : Vector2i) -> void:
	if vector == Vector2i.ZERO:
		velocity = Vector2.ZERO
		return
	
	velocity = Vector2(vector.x, vector.y).normalized() * speed

func is_movement_locked() -> bool:
	return _movement_locked

func lock_movement() -> void:
	velocity = Vector2.ZERO
	_movement_locked = true

func unlock_movement() -> void:
	_movement_locked = false
