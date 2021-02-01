extends Node2D

var radius = 32
#var isClicked = false
onready var sprite = get_node("Sprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scaleSprite()
	
func scaleSprite():
	var img_size = sprite.texture.get_size().x / 2
	sprite.scale = Vector2(1, 1) * radius / img_size

#func _input(event):
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
#		if (event.position - self.position).length() < radius:
#			self.isClicked = true
#			print("click")

func _process(delta):
	radius += delta * 10
	self.scaleSprite()
