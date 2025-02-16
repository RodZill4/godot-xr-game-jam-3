extends StaticBody3D


func _ready():
	update_scores()

func update_scores():
	var game_names : String = ""
	var game_scores : String = ""
	for g in get_tree().get_nodes_in_group("games"):
		game_names += g.game_name+"\n"
		game_scores += g.get_highest_score()+"\n"
		if not g.is_connected("win", self.update_scores):
			g.connect("win", self.update_scores)
	$Names.text = game_names
	$Scores.text = game_scores
