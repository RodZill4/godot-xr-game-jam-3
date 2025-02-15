extends Area3D


signal passed()


func enable(active : bool = false):
	visible = true
	$TimeLabel.visible = false
	$Arrow.visible = active
	$CollisionShape.set_deferred("disabled", not active)

func disable():
	visible = false
	$CollisionShape.set_deferred("disabled", true)

func _on_body_entered(_body):
	$AudioStreamPlayer.play()
	passed.emit()

func set_time_string(string : String):
	$TimeLabel.text = string
	$TimeLabel.visible = true
