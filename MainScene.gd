extends Node2D

var Target = preload("res://target.tscn")
onready var speed_label = get_node("speed_label")
onready var best_speed_label = get_node("best_speed_label")

var green = Color(181/255.0, 214/255.0, 61/255.0)
var lightBlue = Color(0.02, 0.671, 0.294)
var darkBlue = Color(0.004, 0.831, 0.271)
var mediumBlue = Color(0.004, 0.282, 0.282)
var yellow = Color(0.051, 0.298, 0.267)
var orange = Color(0.059, 0.345, 0.384)
var lightOrange = Color(0.059, 0.98, 0.894)
var brown = Color(0.047, 0.153, 0.38)

var accumulator = 0
var lastSpawnTime = 0
var lastSpeedupTime = 0

var startingFrequency = 1.0
var spawnFrequency: float
var targets = Array()

var bestSpeed = 1.0
var freezeSpeedLabel = false

func _ready():
	self.targets.push_back(self.spawn_target())
	self.spawnFrequency = self.startingFrequency

func spawn_target():
	var t = Target.instance()
	var pad = t.maxRadius

	var vp = get_viewport_rect().size
	var x = rand_range(pad, vp.x - pad)
	var y = rand_range(pad, vp.y - pad)
	t.position = Vector2(x, y)
	
	add_child(t)
	return t

func _process(delta):
	self.accumulator += delta

	if self.accumulator - self.lastSpawnTime > self.spawnFrequency:
		self.targets.push_back(self.spawn_target())
		self.lastSpawnTime = self.accumulator
	
	if self.accumulator - self.lastSpeedupTime > 1.0:
		self.spawnFrequency *= .98
		self.lastSpeedupTime = self.accumulator
		if self.spawnFrequency < self.bestSpeed:
			self.bestSpeed = self.spawnFrequency
			self.speed_label.add_color_override("font_color", self.green)
		self.updateLabel()
		
	for t in self.targets:
		if t.dead: self.reset()

func unfreezeSpeedLabel():
	self.freezeSpeedLabel = false
	
func reset():
	if self.spawnFrequency >= self.bestSpeed:
		self.freezeSpeedLabel = true
		get_tree().create_timer(2.0).connect("timeout", self, "unfreezeSpeedLabel")
		get_tree().create_timer(2.0).connect("timeout", self, "resetCurrentSpeedColor")

	self.spawnFrequency  = min(self.spawnFrequency * 2, self.startingFrequency)
	self.updateLabel()

	for t in self.targets: remove_child(t)
	self.targets.clear()

	self.accumulator = -1 # give an extra second after clearing the board
	self.lastSpawnTime = 0
	self.lastSpeedupTime = 0

func updateLabel():
	if !self.freezeSpeedLabel:
		self.speed_label.text = str(int(1.0/self.spawnFrequency*100)/100.0) + " targets/second"
	self.best_speed_label.text = str(int(1.0/self.bestSpeed*100)/100.0) + " (best)"

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var clickedTarget = false
		for t in self.targets:
			if (event.position - t.position).length() < t.radius:
					remove_child(t)
					self.targets.erase(t)
					clickedTarget = true

		if !clickedTarget: reset()
	
func resetCurrentSpeedColor():
	self.speed_label.add_color_override("font_color", Color(1,1,1))
