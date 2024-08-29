extends Node3D

@export var eye: Node3D
@export var speed: float = 200.0
@export_range(0.0, 5.0) var gravity_multiplier: float = 0.6
@export_range(0.01, 0.98) var bounciness: float = 0.4

var _origin: Vector3
var _velocity: Vector3 = Vector3.ZERO
var _last_position: Vector3

func _ready():
	_origin = eye.position
	_last_position = global_position

func _physics_process(delta):
	const max_distance = 0.35

	var current_position = global_position

	# Calculate the downward direction based on the node's rotation
	var gravity_direction = global_transform.basis.y * -1
	var gravity = gravity_direction * 10  # Assuming a gravity strength of 10 units

	_velocity += gravity * gravity_multiplier * delta
	_velocity += (_last_position - current_position) * 500.0 * delta
	_velocity.z = 0.0

	var ep = eye.position

	ep += _velocity * speed * delta

	var direction = ep - _origin
	var angle = atan2(direction.y, direction.x)

	if direction.length() > max_distance:
		var normal = -direction.normalized()
		_velocity = _velocity.bounce(normal) * bounciness

		ep = Vector3(
			cos(angle) * max_distance,
			sin(angle) * max_distance,
			_origin.z
		)

	eye.position = ep
	_last_position = current_position
