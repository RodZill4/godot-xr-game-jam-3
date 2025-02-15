extends Node3D

@export var broom_name : String
@export var broom_music : AudioStream


@export var maximum_speed : float = 10.0
@export var rotation_speed : float = 2.0
@export var vertical_speed : float = 1.0
@export var decay : float = 200.0
@export var lean_amount : float = 0.1

var hand : Node3D


func _ready():
	set_hand(null)

func set_hand(h : Node3D):
	hand = h
	if h:
		set_process(true)
	else:
		set_process(false)
		set_rotation(Vector3(-0.8, 0.0, 0.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var p = get_parent().to_local(hand.get_global_position())
	rotation.x = clamp(Vector2(Vector2(p.x, p.y).length(), p.z).angle(), -1.0, -0.4)
	rotation.z = clamp(Vector2(p.y, -p.x).angle(), -0.5, 0.5)
