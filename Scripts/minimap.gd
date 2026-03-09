extends Panel

@onready var player = $/root/Game/Player;
@onready var Bounds = $/root/Game/Bounds;
@onready var Enemies = $/root/Game/Enemies;

@onready var scale_factor = size.x / Bounds.size.x;
@onready var scale_vector = Vector2(scale_factor, scale_factor);
var origin_vector = Vector2(size.x / 2, size.y / 2);

var min_pos = Vector2(10, 10);
var max_pos = size - Vector2(10, 10);

const PLAYER_COLOR = Color(255, 255, 255);
const ENEMY_COLOR = Color(200, 0.0, 0.0, 1.0);

func _process(_delta):
	queue_redraw();

func _draw():
	# Draw player
	var player_pos = player.position * scale_vector + origin_vector
	draw_circle(player_pos.clamp(min_pos, max_pos), 5, PLAYER_COLOR, true);
	
	# Draw enemies
	var enemies = Enemies.get_children(false);
	for enemy in enemies:
		var enemy_pos = enemy.position * scale_vector + origin_vector
		draw_circle(enemy_pos.clamp(min_pos, max_pos), 3, ENEMY_COLOR, true);
