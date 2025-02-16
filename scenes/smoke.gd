extends MeshInstance3D


func place(v1 : Vector3, v2 : Vector3):
	global_position = 0.5*(v1+v2)
	var diff : Vector3 = v2-v1
	global_rotation = Vector3(atan2(Vector2(diff.x, diff.z).length(), diff.y), atan2(diff.x, diff.z), 0.0)
