extends Node3D


func _on_animation_player_animation_finished(_anim_name):
	await get_tree().create_timer(randf()*2.0+0.3).timeout
	$AnimationPlayer.play("blink")
