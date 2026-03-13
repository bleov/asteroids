extends Node2D

var bullet_template = preload("res://Scenes/Bullet.tscn");

@onready var game: Node2D = $/root/Game;
@onready var player: Area2D = game.get_node("Player");
@onready var Bullets: Node = game.get_node("Bullets");
@onready var FireTimer: Timer = $FireTimer;

const base_fire_rate = 0.28;
const base_projectile_speed = 550.0;
const base_damage = 1;

@export var fire_rate: float = base_fire_rate;
@export var projectile_speed: float = base_projectile_speed;
@export var damage: int = base_damage;

var upgrades = [
	{
		name = "Fire Rate",
		description = "Fire 10% more frequently",
		max = 8,
		level = 0,
		apply = (func(level: int):
		fire_rate = base_fire_rate * (1.0 - (0.1 * level));
		)
	},
	{
		name = "Projectile Speed",
		description = "Bullets move 10% faster",
		max = 8,
		level = 0,
		apply = (func(level: int):
		projectile_speed = base_projectile_speed * (1.0 + (0.1 * level));
		)
	},
	{
		name = "Damage",
		description = "Bullets deal more damage",
		max = 3,
		level = 0,
		apply = (func(level: int):
		damage = base_damage + level;
		)
	}
];

func _ready():
	FireTimer.wait_time = fire_rate;
	FireTimer.start();

func _on_fire_timer_timeout():
	# fire gun
	if (Input.is_action_pressed("fire")): return
	var bullet = bullet_template.instantiate();
	bullet.position = position;
	bullet.rotation_degrees = rotation_degrees;
	bullet.move_speed = projectile_speed;
	bullet.damage = damage;
	Bullets.add_child(bullet);
	FireTimer.wait_time = fire_rate;
