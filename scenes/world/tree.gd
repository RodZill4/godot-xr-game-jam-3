extends StaticBody3D


func _ready():
	$LeavesArea.body_entered.connect(self._on_leaves_area_body_entered)

func _on_leaves_area_body_entered(body):
	if body.has_method("fly_in_tree"):
		body.fly_in_tree()
	$LeavesArea/LeavesSound.play()
