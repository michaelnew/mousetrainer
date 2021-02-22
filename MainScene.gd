extends Node2D

var Target = preload("res://target.tscn")
onready var speed_label = get_node("speed_label")
onready var best_speed_label = get_node("best_speed_label")
var borderColor = StateManager.clear

var accumulator = 0
var lastSpawnTime = 0
var lastSpeedupTime = 0

var spawnFrequency: float
var targets = Array()

var freezeSpeedLabel = false

func _ready():
	self.spawnFrequency = StateManager.getStartFrequency()
	self.targets += self.spawn_target(StateManager.getSpawnCount())
	self.updateLabel()

func spawn_target(count):
	var newTargets = Array()
	var r = StateManager.getSpawnArea(get_viewport_rect().size)
	
	for i in count:
		var t = Target.instance()
		t.lifeTime = self.spawnFrequency * 2
		var pad = t.maxRadius
		
		var x = rand_range(r.position.x + pad, r.position.x + r.size.x - pad)
		var y = rand_range(r.position.y + pad, r.position.y + r.size.y - pad)
		t.position = Vector2(x, y)
	
		add_child(t)
		newTargets.push_back(t)
		
	return newTargets

func _draw():
	var vp = get_viewport().get_visible_rect().size
	draw_rect(Rect2(0,0,1,vp.y), self.borderColor)
	draw_rect(Rect2(0,0,vp.x,1), self.borderColor)
	draw_rect(Rect2(vp.x-1,0,vp.x,vp.y), self.borderColor)
	draw_rect(Rect2(0,vp.y-1,vp.x,1), self.borderColor)

func _process(delta):
	self.accumulator += delta

	if self.accumulator - self.lastSpawnTime > self.spawnFrequency:
		self.targets += self.spawn_target(StateManager.getSpawnCount())
		self.lastSpawnTime = self.accumulator

	if self.accumulator - self.lastSpeedupTime > 1.0:
		self.spawnFrequency *= .98
		self.lastSpeedupTime = self.accumulator
		if self.spawnFrequency < StateManager.getBestSpeed():
			StateManager.setBestSpeed(self.spawnFrequency)
			self.speed_label.add_color_override("font_color", StateManager.green)
			self.borderColor = StateManager.green
			update()
		self.updateLabel()

	for t in self.targets:
		if t.dead: self.reset()

func unfreezeSpeedLabel():
	self.freezeSpeedLabel = false
	
func reset():
	if self.spawnFrequency >= StateManager.getBestSpeed():
		self.freezeSpeedLabel = true
		get_tree().create_timer(2.0).connect("timeout", self, "unfreezeSpeedLabel")
		get_tree().create_timer(2.0).connect("timeout", self, "resetCurrentSpeedColor")
		StateManager.save_game()

	self.spawnFrequency  = min(self.spawnFrequency * 2, StateManager.getStartFrequency())
	self.updateLabel()

	for t in self.targets: remove_child(t)
	self.targets.clear()

	self.accumulator = -1 # give an extra second after clearing the board
	self.lastSpawnTime = 0
	self.lastSpeedupTime = 0
	self.borderColor = StateManager.clear
	update()

func updateLabel():
	if !self.freezeSpeedLabel:
		self.speed_label.text = str(int(StateManager.getSpawnCount()/self.spawnFrequency*100)/100.0) + " targets/second"
	self.best_speed_label.text = str(int(StateManager.getSpawnCount()/StateManager.getBestSpeed()*100)/100.0) + " (best)"

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

func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
