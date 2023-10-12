extends Node2D

var angle : float
var num : int
var big := false
var reqInput := ""

func _ready():
	spawn()
	reqInput = ["w","a","s","d"].pick_random()
	$Label.text = reqInput

func spawn():
	scale = Vector2()
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), .5)

func sizeUp():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1,1.1), .25)
	big = true

func sizeDown():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1,1), .25)
	big = false
	
func size():
	return $targetSprite.get_rect().size.x

func rotateSprite(a:float):
	$targetSprite.rotate(a)
