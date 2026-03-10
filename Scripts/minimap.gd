extends Panel

@onready var player = $/root/Game/Player;
@onready var Bounds = $/root/Game/Bounds;
@onready var Enemies = $/root/Game/Enemies;

@onready var scale_factor = size.x / Bounds.size.x;
@onready var scale_vector = Vector2(scale_factor, scale_factor);
var origin_vector = Vector2(size.x / 2, size.y / 2);

var min_pos = Vector2(10, 10);
var max_pos = size - Vector2(10, 10);
var time = 0;

var PLAYER_COLOR = Color.from_rgba8(255, 255, 255, 255);
var ENEMY_COLOR = Color.from_rgba8(200, 0, 0, 255);

func _physics_process(delta): # enemies and player will only update on physics ticks
	time += delta;
	queue_redraw();

func _draw():
	# Draw player
	var player_pos = player.position * scale_vector + origin_vector
	draw_circle(player_pos.clamp(min_pos, max_pos), 5, PLAYER_COLOR, true);
	
	# Draw enemies
	var enemies = Enemies.get_children(false);
	for enemy in enemies:
		if (enemy.died): continue;
		var color = ENEMY_COLOR
		if (!enemy.spawned):
			var pulse = (sin(time * TAU * 0.75) + 1.0) / 2.0 
			var alpha = int(lerp(100, 200, pulse))
			color = Color.from_rgba8(200, 0, 0, alpha);
		var enemy_pos = enemy.position * scale_vector + origin_vector
		draw_circle(enemy_pos.clamp(min_pos, max_pos), 3, color, true);
