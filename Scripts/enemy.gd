extends Area2D

@onready var collision = $CollisionShape2D;
@onready var Bounds = $/root/Game/Bounds;
@onready var Enemies = $/root/Game/Enemies;

var enemy_template = preload("res://Scenes/Enemy.tscn");

const BASE_SCALE = 20;
const SCALE_FACTOR = 20;
const BASE_HEALTH = 1;
const HEALTH_SCALE_FACTOR = 5;

@export var area_type: Enum.AreaType = Enum.AreaType.Enemy;
@export var type: Enum.EnemyType = Enum.EnemyType.Asteroid;
@export var level: int = 1;
@export var health: int = -1;
@export var max_health: int = -1;
@export var velocity: Vector2 = Vector2.ZERO;
@export var is_child: bool = false;
@export var invulnerable: bool = false;

var move_speed = 10;

func _ready():
	health = level;
	max_health = health;
	
	var size = BASE_SCALE + ((level - 1) * SCALE_FACTOR);
	var shape = CircleShape2D.new()
	shape.radius = size;
	collision.shape = shape;
	
	velocity = Vector2(randf_range(5.0, 10.0), 0).rotated(randf_range(0.0, 360.0));

func _physics_process(delta):
	if (!ready): return
	if (health <= 0):
		if (type == Enum.EnemyType.Asteroid && level > 1):
			for i in 2:
				var enemy = enemy_template.instantiate();
				enemy.level = level - 1;
				enemy.type = type;
				enemy.position = position;
				enemy.is_child = true;
				Enemies.add_child(enemy);
		queue_free();
	
	var return_velocity = Bounds.get_return_velocity(position);
	velocity += return_velocity;
	
	position += velocity * move_speed * delta;

func _on_area_entered(area):
	if (area.area_type == Enum.AreaType.Projectile):
		area.queue_free();
		if (!invulnerable):
			health -= 1;
	if (area.area_type == Enum.AreaType.Player):
		velocity += area.velocity.rotated(area.rotation_degrees);
