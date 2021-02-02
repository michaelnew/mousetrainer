extends Node2D

var radius: float
var minRadius = 26
var maxRadius = 42
var lifeTime = 2.0
var life = 0.0
var dead = false

onready var sprite = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.scaleSprite()
	self.radius = self.minRadius
	
func scaleSprite():
	self.radius = self.minRadius + ((self.maxRadius - self.minRadius) * self.life / self.lifeTime)
	var img_size = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1, 1) * radius / img_size

func _process(delta):
	if self.life < self.lifeTime:
		self.life += delta
	else:
		self.dead = true
	self.scaleSprite()
