extends CharacterBody3D


@onready var broom = null

func _ready():
	set_broom(load("res://scenes/brooms/broom_1.tscn").instantiate())

func set_broom(b):
	if broom:
		broom.queue_free()
	broom = b
	if b:
		$Pivot.add_child(b)
		broom.set_hand($Pivot/XR/XROrigin3D/RightHand)
		$MusicPlayer.stop()
		$MusicPlayer.stream = broom.broom_music
		$MusicPlayer.play()

func _process(delta : float):
	var speed_command : float = $Pivot/XR/XROrigin3D/RightHand.get_float("trigger")
	var vertical_command : float = broom.rotation.x+0.7
	var rotation_command : float = broom.rotation.z
	var speed : float = speed_command*broom.maximum_speed
	var d : Vector3 = speed*(-transform.basis.z+Vector3(0, broom.vertical_speed*vertical_command, 0))
	velocity = velocity+(d-velocity)*exp(-broom.decay*delta)
	move_and_slide()
	rotation.y += delta*broom.rotation_speed*rotation_command
	$Pivot.rotation.z = broom.lean_amount*broom.rotation.z*velocity.length()
	$Pivot/XR/XROrigin3D/LeftHand/FPS.text = str(Engine.get_frames_per_second())+" FPS"
