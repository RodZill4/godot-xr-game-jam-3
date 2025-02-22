extends CharacterBody3D


@export var broom_position : float = 0.7


@onready var broom = null

var collided_previous_frame : bool = false
var vignette : XRToolsVignette = null


func _ready():
	set_broom(load("res://scenes/brooms/broom_1.tscn").instantiate())
	process_physics_priority = -200

func set_broom(b):
	if broom:
		if broom.broom_name == b.broom_name:
			return
		broom.queue_free()
	broom = b
	if b:
		$Pivot.add_child(b)
		$MusicPlayer.stop()
		$MusicPlayer.stream = broom.broom_music
		$MusicPlayer.play()

func fly_in_tree():
	velocity *= 0.75
	var hand : XRController3D = broom.controlling_hand as XRController3D
	if hand:
		hand.trigger_haptic_pulse("haptic", 50, 5, 0.3, 0.0)

func _physics_process(delta : float):
	# Show FPS on left wrist
	$Pivot/XR/XROrigin3D/LeftHand/LeftHand/FPS.text = str(Engine.get_frames_per_second())+" FPS"
	# Player movement
	var speed_command : float = 0.0
	var hand : XRController3D = broom.controlling_hand as XRController3D
	if hand:
		speed_command = hand.get_float("trigger")
	var vertical_command : float = broom.rotation.x+0.7
	var rotation_command : float = broom.rotation.z
	var speed : float = speed_command*broom.maximum_speed
	var d : Vector3 = speed*(-transform.basis.z+Vector3(0, broom.vertical_speed*vertical_command, 0))
	velocity = velocity+(d-velocity)*exp(-broom.decay*delta)
	move_and_slide()
	rotation.y += delta*broom.rotation_speed*rotation_command
	var lean_amount = broom.lean_amount*broom.rotation.z*velocity.length()
	$Pivot.rotation.z = clamp(lean_amount, -1.5, 1.5)
	var collided : bool = false
	var collision : KinematicCollision3D = get_last_slide_collision()
	if collision:
		for i in collision.get_collision_count():
			if collision.get_angle(i) > 0.2:
				collided = true
				break
	if collided and not collided_previous_frame:
		$Pivot/XR/XROrigin3D/CollisionSound.play()
		hand.trigger_haptic_pulse("haptic", 100, 10, 0.1, 0.0)
	elif hand and abs(lean_amount) > 0.2:
		hand.trigger_haptic_pulse("haptic", abs(lean_amount)*50, 10*(abs(lean_amount)-0.2), 0.1, 0.0)
	collided_previous_frame = collided

func _on_right_hand_button_pressed(name):
	if name == "by_button":
		if vignette:
			vignette.queue_free()
			vignette = null
		else:
			vignette = preload("res://addons/godot-xr-tools/effects/vignette.tscn").instantiate()
			$Pivot/XR/XROrigin3D/XRCamera3D.add_child(vignette)
