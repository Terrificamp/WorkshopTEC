// white_flash.gdshader
shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    // Preserve alpha — only whiten visible pixels
    COLOR = vec4(
        mix(original.rgb, vec3(1.0), flash_amount),
        original.a
    );
}