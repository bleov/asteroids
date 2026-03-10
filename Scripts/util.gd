extends Node

func set_timeout(time_secs: float, callback: Callable):
	get_tree().create_timer(time_secs, false, false, false).timeout.connect(callback);

func format_seconds(seconds: float) -> String:
	var minutes := int(seconds) / 60
	var secs := int(seconds) % 60
	if (minutes < 10):
		return "%d:%02d" % [minutes, secs]
	return "%02d:%02d" % [minutes, secs]
