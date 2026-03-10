extends Node2D

@onready var time_label = $UI/HUD/Time;
@onready var Enemies = $Enemies;

@export var time = 0;

var enemy_template = preload("res://Scenes/Enemy.tscn");

const ENEMIES_PER_WAVE = 20;

func spawn_wave(wave: int):
	for i in ENEMIES_PER_WAVE * wave:
		var enemy = enemy_template.instantiate();
		enemy.level = randi_range(1, 6);
		enemy.type = Enum.EnemyType.Asteroid
		enemy.position = Vector2.ZERO;
		Enemies.add_child(enemy);

func _on_second_timeout():
	time += 1;
	time_label.text = Util.format_seconds(time);
	
	if (time % 30 == 0):
		spawn_wave(time / 30);
