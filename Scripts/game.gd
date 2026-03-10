extends Node2D

@onready var time_label = $UI/HUD/Time;
@onready var Enemies = $Enemies;
@onready var Bounds = $/root/Game/Bounds;

@export var time: int = 0;
@export var wave: int = 1;

var enemy_template = preload("res://Scenes/Enemy.tscn");

const BASE_ENEMIES_PER_WAVE = 70;

func _ready():
	spawn_wave(1);

func spawn_enemy(type: Enum.EnemyType, level: int, spawn_pos: Vector2):
	var enemy = enemy_template.instantiate();
	enemy.level = level;
	enemy.type = type;
	enemy.position = spawn_pos;
	Enemies.add_child(enemy);
	return enemy;

func spawn_wave(wave_num: int):
	var enemy_count = BASE_ENEMIES_PER_WAVE
	if (wave_num > 1):
		enemy_count -= 5 * wave_num;
		enemy_count = max(enemy_count, 30);
	for i in enemy_count:
		var new_pos = Vector2(randi_range(Bounds.position.x, Bounds.size.x / 2), randi_range(Bounds.position.y, Bounds.size.y / 2));
		spawn_enemy(Enum.EnemyType.Asteroid, randi_range(max(1, wave_num - 3 ), wave_num), new_pos);

func _on_second_timeout():
	time += 1;
	time_label.text = Util.format_seconds(time);
	
	if (time % 30 == 0):
		wave = time / 30 + 1;
		spawn_wave(wave);

func _process(_delta):
	if (Input.is_action_just_pressed("debug_spawn_giant")):
		spawn_enemy(Enum.EnemyType.Asteroid, 7, get_local_mouse_position())
