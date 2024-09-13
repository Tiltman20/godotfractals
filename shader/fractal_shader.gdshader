shader_type canvas_item;

uniform float zoom : hint_range(0.1, 100.0) = 1;
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec2 resolution = vec2(10000.0, 10000.0);
uniform vec2 high_precision_offset;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// Berechne die Mitte des Bildes
    vec2 center = resolution * 0.5;
    
    // Berechne das Seitenverhältnis
    highp float aspect_ratio = resolution.x / resolution.y;
    
    // Korrigiere die Koordinaten, um das Seitenverhältnis zu berücksichtigen
    highp vec2 corrected_uv = (FRAGCOORD.xy / resolution - 0.5) * vec2(aspect_ratio, 1.0);

    // Berechne c basierend auf den aktuellen Pixel-Koordinaten und der Mitte
    highp vec2 c = corrected_uv * zoom + high_precision_offset;

    // Setze z auf (0.0, 0.0)
    highp vec2 z = vec2(0.0);

    // Dynamically adjust the maximum number of iterations based on the zoom level
    int max_iterations = 50000;

    highp float color_steps = 255.0;

    highp float escape_radius = 200.0;
    int iter_count = 0;
    for (int i = 0; i < max_iterations; i++) {
		iter_count = i;
        z = vec2(
            z.x * z.x - z.y * z.y + c.x,
            2.0 * z.x * z.y + c.y
        );
        if (length(z) > escape_radius) {
            break;
        }
    }

    // Zeige die Iterationsanzahl als Farbe
    COLOR = vec4(vec3(float(iter_count) / float(color_steps)), 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
