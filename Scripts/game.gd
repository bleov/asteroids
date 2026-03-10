extends Node2D

@onready var time_label = $UI/HUD/Time;
@onready var Enemies = $Enemies;
@onready var Bounds = $/root/Game/Bounds;

@export var time = 0;

var enemy_template = preload("res://Scenes/Enemy.tscn");

const BASE_ENEMIES_PER_WAVE = 70;

func _ready():
	spawn_wave(1);

func spawn_enemy(type: Enum.EnemyType, level: int, position: Vector2):
	var enemy = enemy_template.instantiate();
	enemy.level = level;
	enemy.type = type;
	enemy.position = position;
	Enemies.add_child(enemy);

func spawn_wave(wave: int):
	var enemy_count = BASE_ENEMIES_PER_WAVE
	if (wave > 1):
		enemy_count -= 5 * wave;
		enemy_count = max(enemy_count, 30);
	for i in enemy_count:
		var new_pos = Vector2(randi_range(Bounds.position.x, Bounds.size.x / 2), randi_range(Bounds.position.y, Bounds.size.y / 2));
		spawn_enemy(Enum.EnemyType.Asteroid, randi_range(max(1, wave - 3 ), wave), new_pos);

func _on_second_timeout():
	time += 1;
	time_label.text = Util.format_seconds(time);
	
	if (time % 30 == 0):
		spawn_wave(time / 30 + 1);
