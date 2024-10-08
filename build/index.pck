GDPC                �                                                                         P   res://.godot/exported/133200997/export-3ad5c15c4f3250da0cc7c1af1770d85f-main.scn       �      �Jr��)����d�Y�    \   res://.godot/exported/133200997/export-a6134423b86d7ffff48bd568518e55b1-fractal_shader.res  �      �      4H���32�8-�/�L    ,   res://.godot/global_script_class_cache.cfg  0#             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex`            ：Qt�E�cO���       res://.godot/uid_cache.bin  '      l       $���	����TȚ       res://icon.svg  P#      �      k����X3Y���f       res://icon.svg.import   �!      �       �]�*��g��mY�/       res://project.binary�'      �      ~iB!����P�)��       res://scenes/Camera2D.gd�	      �      �=���E�� �ύ��       res://scenes/main.gd        �      u�tC3f�LԺb�0.U       res://scenes/main.tscn.remapP"      a       
��������S8z�s    $   res://shader/fractal_shader.gdshader�      �      �汃u��_iP�j    (   res://shader/fractal_shader.tres.remap  �"      k       ���>24��>)���a                extends Node2D

var zoom = 1
var offset = Vector2(0, 0)
var resolution = Vector2(10000, 10000) # Initiale Auflösung
var _material : ShaderMaterial

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		offset.y -= 0.001 * zoom
	if Input.is_action_pressed("ui_down"):
		offset.y += 0.001 * zoom
	if Input.is_action_pressed("ui_left"):
		offset.x -= 0.001 * zoom
	if Input.is_action_pressed("ui_right"):
		offset.x += 0.001 * zoom
	
	var viewport_size = get_viewport().size
	_material.set_shader_parameter("zoom", zoom)
	_material.set_shader_parameter("offset", offset)
	_material.set_shader_parameter("resolution", viewport_size)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print("zoom out")
			zoom *= 0.99
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 1.01
	elif event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			offset -= event.relative / (resolution * zoom)
     RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    shader    script 	   _bundled       Script    res://scenes/main.gd ��������	   Material !   res://shader/fractal_shader.tres �"�l���u
   Texture2D    res://icon.svg Q2�\�b      local://ShaderMaterial_d211j �         local://PackedScene_xsrrg �         ShaderMaterial             PackedScene          	         names "         Node2D 	   material    script 	   Sprite2D 	   position    scale    texture    	   variants                                    
    @D ��C
   �?A��@               node_count             nodes        ��������        ����                                  ����                                     conn_count              conns               node_paths              editable_instances              version             RSRC        extends Camera2D


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
shader_type canvas_item;

uniform float zoom : hint_range(0.1, 100.0) = 1;
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec2 resolution = vec2(10000.0, 10000.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// Berechne die Mitte des Bildes
    vec2 center = resolution * 0.5;
	
	// Berechne die aktuelle Position im Bild
    vec2 uv = FRAGCOORD.xy / resolution; // Normalisierte Koordinaten [0, 1]
    
    // Berechne das Seitenverhältnis
    float aspect_ratio = resolution.x / resolution.y;
    
    // Korrigiere die Koordinaten, um das Seitenverhältnis zu berücksichtigen
    vec2 corrected_uv = (uv - 0.5) * vec2(aspect_ratio, 1.0);

    // Berechne c basierend auf den aktuellen Pixel-Koordinaten und der Mitte
    vec2 c = corrected_uv * zoom + offset;

    // Setze z auf (0.0, 0.0)
    vec2 z = vec2(0.0);
    int iter_count = 0;
    for (int i = 0; i < 50000; i++) {
		iter_count = i;
        z = vec2(
            z.x * z.x - z.y * z.y + c.x,
            2.0 * z.x * z.y + c.y
        );
        if (length(z) > 2.0) {
            //iter_count = i;
            break;
        }
    }

    // Zeige die Iterationsanzahl als Farbe
    COLOR = vec4(vec3(float(iter_count) / 1000.0), 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
          RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    shader    shader_parameter/zoom    shader_parameter/offset    shader_parameter/resolution    script       Shader %   res://shader/fractal_shader.gdshader ��������      local://ShaderMaterial_6q2cq v         ShaderMaterial                         �?   
              
    @F @F      RSRC           GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c8g2ne67wavkj"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-3ad5c15c4f3250da0cc7c1af1770d85f-main.scn"
               [remap]

path="res://.godot/exported/133200997/export-a6134423b86d7ffff48bd568518e55b1-fractal_shader.res"
     list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              )MS��r�m   res://scenes/main.tscn�"�l���u    res://shader/fractal_shader.tresQ2�\�b   res://icon.svg    ECFG      application/config/name         godot_fractals     application/run/main_scene          res://scenes/main.tscn     application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg     display/window/size/mode            display/window/stretch/mode         canvas_items   input/zoom_in�              events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   Q   	   key_label             unicode    q      echo          script            deadzone      ?   input/zoom_out�              events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   E   	   key_label             unicode    e      echo          script            deadzone      ?               