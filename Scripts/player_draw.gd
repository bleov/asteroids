extends Node2D

const FILL_COLOR = Color(0, 0, 0);
const OUTLINE_COLOR = Color(255, 255, 255);
const SIZE = 30;

func _ready():
	scale = Vector2(1, 1);

func _draw():
	var points : PackedVector2Array = [Vector2(SIZE, -SIZE), Vector2(0, SIZE), Vector2(-SIZE, -SIZE)];
	var fill_colors : PackedColorArray = [FILL_COLOR, FILL_COLOR, FILL_COLOR];
	
	draw_polygon(points, fill_colors);
	draw_polyline(points, OUTLINE_COLOR, 5, true);
	draw_line(Vector2(-SIZE - 1, -SIZE), Vector2(SIZE + 1, -SIZE), OUTLINE_COLOR, 5, true);
	queue_redraw();
