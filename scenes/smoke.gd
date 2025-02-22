extends MeshInstance3D


func place(v1 : Vector3, v2 : Vector3, last_trail = null) -> Vector3:
	global_position = 0.5*(v1+v2)
	var diff : Vector3 = v2-v1
	global_rotation = Vector3(atan2(Vector2(diff.x, diff.z).length(), diff.y), atan2(diff.x, diff.z), 0.0)
	diff = diff.normalized()
	var last_direction : Vector3
	if last_trail:
		last_direction = (diff+last_trail.get_instance_shader_parameter("direction2")).normalized()
	else:
		last_direction = diff
	set_instance_shader_parameter("direction1", last_direction)
	set_instance_shader_parameter("direction2", diff)
	return diff
