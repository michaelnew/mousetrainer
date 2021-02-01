extends Node2D

var Target = preload("res://target.tscn")
var accumulator = 0
var lastSpawnTime = 0
var spawnFrequency = 1.0
var targets = Array()

func _ready():
	self.targets.push_back(self.spawn_target())

func spawn_target(_position=null):
	var t = Target.instance()
	if !_position:
		var vp = get_viewport_rect().size
		var x = rand_range(0, vp.x)
		var y = rand_range(0, vp.y)
		t.position = Vector2(x, y)
	add_child(t)
	return t

func _process(delta):
	
	self.accumulator += delta
	if self.accumulator - self.lastSpawnTime > self.spawnFrequency:
		self.targets.push_back(self.spawn_target())
		self.lastSpawnTime = self.accumulator

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var clickedTarget = false
		for t in self.targets:
			if (event.position - t.position).length() < t.radius:
					remove_child(t)
					self.targets.erase(t)
					clickedTarget = true

		if clickedTarget:
			self.spawnFrequency *= .98
		else:
			self.spawnFrequency *= 2
			for t in self.targets:
				remove_child(t)
				self.targets.erase(t)
