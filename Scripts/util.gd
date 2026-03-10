extends Node

func set_timeout(time_secs: float, callback: Callable):
	get_tree().create_timer(time_secs, false, false, false).timeout.connect(callback);
