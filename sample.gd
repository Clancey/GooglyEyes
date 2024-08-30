extends Node3D
@onready var camera = $Camera3D
@onready var mesh = $MeshInstance3D

func _process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	
	var plane:Plane = Plane(Vector3.UP, 0)  # Assuming the plane is at y=0 and normal is up (Y-axis)
	var target_position = plane.intersects_ray(ray_origin, ray_direction)
	
	if target_position:
		# Inverse the Y axis
		target_position.y = -target_position.y
		
		mesh.look_at(target_position, Vector3.UP)
		mesh.global_transform.origin = global_transform.origin.lerp(target_position, 0.1)  # Smooth follow, adjust 0.1 as needed
