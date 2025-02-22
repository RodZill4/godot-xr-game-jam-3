extends XRToolsPickable


var initial_transform : Transform3D
var last_position : Vector3
var last_trail = null


func _ready():
	super._ready()
	initial_transform = transform
	set_process(false)

func _on_grabbed(pickable, by):
	print("Wand grabbed")
	$RespawnTimer.stop()

func _on_dropped(_pickable):
	$RespawnTimer.start()
	set_process(false)

func _on_highlight_updated(_pickable, enable):
	$HighlightMeshInstance.visible = enable

func _on_respawn_timer_timeout():
	transform = initial_transform


func _on_action_pressed(pickable):
	set_process(true)
	last_position = $Tip.global_position
	last_trail = null

func _on_action_released(pickable):
	set_process(false)


func _process(_delta):
	var p : Vector3 = $Tip.global_position
	var diff : Vector3 = p-last_position
	if diff.length() > 7:
		var smoke = preload("res://scenes/smoke.tscn").instantiate()
		get_parent().add_child(smoke)
		smoke.place(p, last_position, last_trail)
		last_position = p
		last_trail = smoke
		
