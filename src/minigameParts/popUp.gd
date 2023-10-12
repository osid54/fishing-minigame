extends Node2D

@export var target : PackedScene
@export var rotateSpeed := 2
var targets := []
var radius := 182
var moving := false
var rot := 1.5 * PI

func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("space"):
		create()
		
	checkHit()
		
	if rot >= TAU:
		rot -= TAU
	

func _physics_process(delta):
	if moving:
		$lineHolder.rotate(rotateSpeed * delta)
		rot += rotateSpeed * delta

func checkCollisions(t: float) -> bool:
	if abs(t - 1.5 * PI) < PI/8.0:
		return false
	for tar in targets:
		if (abs(t - tar.angle) < tar.size()/radius or 
		abs(t - tar.angle) > TAU - tar.size()/radius):
			return false
	return true
		
func clear():
	for child in $targets.get_children():
		child.queue_free()
	targets.clear()

func create():
	moving = false
	clear()
	$lineHolder.rotation = 0
	rot = 1.5 * PI
	startMove()
	for i in randi_range(1,5):
		var t = target.instantiate()
		t.num = targets.size()
		t.angle = randf_range(0,TAU)
		while !checkCollisions(t.angle):
			t.angle = randf_range(0,TAU)
		t.position = Vector2(radius*cos(t.angle),radius*sin(t.angle))
		t.rotateSprite(t.angle)
		targets.append(t)
		$targets.add_child(t)
	targets.sort_custom(targetSort)
	print("order")
	for t in targets:
		print(t.angle)

func checkAction():
	if Input.is_action_just_pressed("w"): return "w"
	if Input.is_action_just_pressed("a"): return "a"
	if Input.is_action_just_pressed("s"): return "s"
	if Input.is_action_just_pressed("d"): return "d"
	return ""

func checkHit():
	for t in targets:
		if abs(t.angle - rot) < $lineHolder/Line.get_rect().size.x/radius:
			if !t.big:
				t.sizeUp()
			if checkAction() == t.reqInput:
				t.modulate = "GREEN"
		else:
			if t.big:
				t.sizeDown()
				
func targetSort(a, b):
	var ang1 = a.angle
	var ang2 = b.angle
	if ang1 > 1.5*PI:
		ang1 -= TAU
	if ang2 > 1.5*PI:
		ang2 -= TAU
	if ang1 < ang2:
		return true
	return false

func startMove():
	await get_tree().create_timer(1).timeout
	moving = true
