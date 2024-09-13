extends Node2D

var zoom = 1
var offset = Vector2(0, 0)
var resolution = Vector2(10000, 10000) # Initiale Auflösung
var _material : ShaderMaterial
var high_precision_offset = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	var fractal_shader = preload("res://shader/fractal_shader.gdshader") as Shader
	_material = ShaderMaterial.new()
	_material.shader = fractal_shader
	
	# Weisen das ShaderMaterial dem Sprite zu
	$Sprite2D.material = _material
	
	_material.set_shader_parameter("zoom", zoom)
	_material.set_shader_parameter("offset", offset)
	_material.set_shader_parameter("resolution", resolution)
	_material.set_shader_parameter("high_precision_offset", high_precision_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		offset.y -= 0.01 * zoom
	if Input.is_action_pressed("ui_down"):
		offset.y += 0.01 * zoom
	if Input.is_action_pressed("ui_left"):
		offset.x -= 0.01 * zoom
	if Input.is_action_pressed("ui_right"):
		offset.x += 0.01 * zoom

	update_high_precision_offset()
	
	var viewport_size = get_viewport().size
	_material.set_shader_parameter("zoom", zoom)
	_material.set_shader_parameter("offset", offset)
	_material.set_shader_parameter("resolution", viewport_size)
	_material.set_shader_parameter("high_precision_offset", high_precision_offset)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print("zoom in")
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("zoom out")
			zoom_out()
	elif event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			offset -= event.relative / (resolution * zoom)
			update_high_precision_offset()


func zoom_in():
	var center = get_viewport().size / 2.0
	offset += (center / resolution) * (1.0 - 1.01) * zoom
	zoom *= 1.01
	update_high_precision_offset()

func zoom_out():
	var center = get_viewport().size / 2.0
	offset += (center / resolution) * (1.0 - 0.99) * zoom
	zoom *= 0.99
	update_high_precision_offset()


func update_high_precision_offset():
	high_precision_offset = offset * zoom