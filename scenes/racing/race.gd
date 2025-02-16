extends Node3D


@export var game_name : String
@export var show_gates : int = 5

@onready var checkpoints : Node = $Checkpoints

var current_index : int = -1
var current = null
var start_time : int = 0
var score : Array[int] = []
var best_score : Array[int] = []


signal win()


func _ready():
	initialize()

func initialize():
	disable()
	current_index = 0
	current = checkpoints.get_child(current_index)
	current.enable(true)
	current.passed.connect(self.start)

func disable():
	for c in checkpoints.get_children():
		c.disable()
	current_index = -1
	current = null
	set_process(false)

func initialize_all_games():
	for g in get_tree().get_nodes_in_group("games"):
		g.initialize()

func disable_other_games():
	for g in get_tree().get_nodes_in_group("games"):
		if g != self:
			g.disable()

func start():
	disable_other_games()
	current.passed.disconnect(self.start)
	current.disable()
	current_index += 1
	current = checkpoints.get_child(current_index)
	current.enable(true)
	current.passed.connect(self.passed)
	for i in range(2, min(2+show_gates, checkpoints.get_child_count())):
		checkpoints.get_child(i).enable()
	start_time = Time.get_ticks_msec()
	score = []
	set_process(true)

func passed():
	current.passed.disconnect(self.passed)
	current.disable()
	current_index += 1
	if current_index == checkpoints.get_child_count():
		score.append(Time.get_ticks_msec()-start_time)
		if best_score.is_empty():
			best_score = score.duplicate()
		else:
			for i in range(score.size()):
				if score[i] < best_score[i]:
					best_score[i] = score[i]
		win.emit()
		$Applause.play()
		initialize_all_games()
	else:
		current = checkpoints.get_child(current_index)
		current.passed.connect(self.passed)
		current.enable(true)
		score.append(Time.get_ticks_msec()-start_time)
		if current_index+show_gates < checkpoints.get_child_count():
			checkpoints.get_child(current_index+show_gates).enable()

func get_time_string(time : int) -> String:
	return "%d:%02d.%02d" % [ time/60000, (time/1000)%60, (time/10)%100]

func get_highest_score() -> String:
	if best_score.is_empty():
		return "N/A"
	else:
		return get_time_string(best_score[best_score.size()-1])

func _process(_delta):
	current.set_time_string(get_time_string(Time.get_ticks_msec() - start_time))
