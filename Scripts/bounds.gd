extends Control

const BOX_SIZE = 100;
const COLOR = Color(255, 255, 255, 0.2)

@onready var rect = get_rect();

func is_inside_bounds(pos: Vector2):
	return rect.has_point(pos);

func _draw():
	for x in range(0, size.x, BOX_SIZE):
		draw_line(Vector2(x, 0), Vector2(x, size.y), COLOR, 2, false);
	for y in range(0, size.y, BOX_SIZE):
		draw_line(Vector2(0, y), Vector2(size.x, y), COLOR, 2, false);
