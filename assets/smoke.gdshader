// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_add, cull_disabled, unshaded, skip_vertex_transform;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float width = 2.0;

instance uniform vec3 direction1;
instance uniform vec3 direction2;

void vertex() {
	vec3 world_position = (MODEL_MATRIX*vec4(VERTEX, 1.0)).xyz;
	world_position += (UV.x-0.5)*width*normalize(cross(world_position-CAMERA_POSITION_WORLD, mix(direction1, direction2, UV.y)));
	VERTEX = (VIEW_MATRIX*vec4(world_position, 1.0)).xyz;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

}
