@tool
extends Node

var line
var lastLine
var cols
var started = false
var collider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# retrieve the nodes we need
	collider=null
	for i in get_children():
		if typeof(i)==typeof(CollisionObject2D):
			collider=i
	if collider == null:
		collider = StaticBody2D.new()
		add_child(collider)
		collider.position=Vector2(0,0)
	print(collider)
		
	# store the OG values 
	lastLine = self.points.duplicate()
	
	# create the rects
	recomputeRect()
	
	started = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print("b")
	if not started:
		_ready()
	if lastLine != self.points:
		recomputeRect()
		lastLine=self.points
			
func recomputeRect() -> void:
	# remove all the unneeded rects
	for i in self.collider.get_children():
		self.collider.remove_child(i)
		i.queue_free()
	
	# get the width of the line
	var w = self.width
	
	# create the colliders we need
	var prev = lastLine[0]
	var joint		# we define joint here so we can remove the last one if needed
	var jointShape = CircleShape2D.new()
	jointShape.radius = w/2
	var num = 1
	for i in self.points.slice(1):
		var colShape = CollisionShape2D.new()
		var rectShape = RectangleShape2D.new()
		joint = CollisionShape2D.new()
		rectShape.size=Vector2(prev.distance_to(i),w)
		colShape.shape=rectShape
		joint.shape = jointShape
		var mid = (prev+i)/2
		colShape.position = mid
		joint.position = i
		colShape.rotation = prev.angle_to_point(i)
		colShape.name = "Rect"+str(num)
		num+=1
		collider.add_child(colShape)
		collider.add_child(joint)
		prev = i
	collider.remove_child(joint)
	joint.queue_free()
