shader_type spatial;

uniform sampler2D map : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 grass_color_1 : source_color;
uniform vec3 grass_color_2 : source_color;
uniform float grass_density;
uniform float grass_sharpness = 1.0;
uniform vec3 road_color_1 : source_color;
uniform vec3 road_color_2 : source_color;
uniform float road_sharpness = 1.0;
uniform float road_density;

uniform float max_noise_distance = 100.0;

vec2 hash(vec2 p) {
	p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float simplex_noise(vec2 p) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;

	vec2  i = floor( p + (p.x+p.y)*K1 );
    vec2  a = p - i + (i.x+i.y)*K2;
    float m = step(a.y,a.x); 
    vec2  o = vec2(m,1.0-m);
    vec2  b = a - o + K2;
	vec2  c = a - 1.0 + 2.0*K2;
    vec3  h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	vec3  n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
    return dot( n, vec3(70.0) );
}

void fragment() {
	float distance = -VERTEX.z;
	float mask = clamp(0.5+(texture(map, UV).r-0.5)*10.0, 0.0, 1.0);
	vec3 c1, c2, c3;
	float d;
	float s;
	if (mask > 0.5) {
		c1 = road_color_1;
		c2 = road_color_2;
		d = road_density;
		s = road_sharpness;
		c3 = 0.5*(grass_color_1+grass_color_2);
		mask = 1.0-mask;
	} else {
		c1 = grass_color_1;
		c2 = grass_color_2;
		d = grass_density;
		s = grass_sharpness;
		c3 = 0.5*(road_color_1+road_color_2);
	}
	float noise;
	if (distance < max_noise_distance) {
		noise = clamp(0.5+s*(simplex_noise(d*UV)-0.5), 0.0, 1.0);
		noise = mix(mix(0.5, noise, 1.0-2.0*mask), 0.5, smoothstep(0.5*max_noise_distance, max_noise_distance, distance));
	} else {
		noise = 0.5;
	}
	ALBEDO=mix(mix(c1, c2, noise), c3, mask);
}

