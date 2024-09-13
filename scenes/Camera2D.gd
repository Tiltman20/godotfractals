extends Camera2D


var zoom_factor = 1.0
var _offset = Vector2(0, 0)

func _ready():
	self.zoom = Vector2(zoom_factor, zoom_factor)
	self.position = offset

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		_offset.y -= 0.01 / zoom_factor
	if Input.is_action_pressed("ui_down"):
		_offset.y += 0.01 / zoom_factor
	if Input.is_action_pressed("ui_left"):
		_offset.x -= 0.01 / zoom_factor
	if Input.is_action_pressed("ui_right"):
		_offset.x += 0.01 / zoom_factor
	
	if Input.is_action_pressed("zoom_in"):
		zoom_factor *= 1.1
		self.zoom = Vector2(zoom_factor, zoom_factor)
	if Input.is_action_pressed("zoom_out"):
		zoom_factor *= 0.9
		self.zoom = Vector2(zoom_factor, zoom_factor)

	self.position = offset
