extends Area3D


@export var broom_scene : PackedScene

@onready var broom_position : Node3D = $MeshInstance/BroomPosition


func _ready():
	var broom : Node = broom_scene.instantiate()
	$MeshInstance/BroomName.text = broom.broom_name
	var broom_visual : Node3D = broom.get_node("Visual")
	broom.remove_child(broom_visual)
	broom.free()
	$BroomPosition.add_child(broom_visual)

func _on_body_entered(body):
	if body.has_method("set_broom"):
		body.set_broom(broom_scene.instantiate())
