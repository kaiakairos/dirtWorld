shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D lightingMask : repeat_disable, filter_nearest;
uniform float line_scale : hint_range(0, 20) = 10;


vec4 multiply(vec4 base, vec4 blend){
	return base * blend;
}

void fragment() {
	vec4 screen = texture(screen_texture,SCREEN_UV);
	vec4 tex = texture(TEXTURE,UV);
	vec4 new = tex;
	
	
	new.r = tex.r*1.125;
	new.g = tex.g*1.05;
	new.b = tex.b*1.115;
		
	
	new = clamp(new,vec4(0.0),vec4(1.0));
	new = floor(new * 16.0)/16.0; // banding
		
	if(new.r > 0.9){ new.r = 1.0; }
	if(new.g > 0.9){ new.g = 1.0; }
	if(new.b > 0.9){ new.b = 1.0; }
		
	COLOR = multiply(screen,new);
		
	vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
	vec4 mask = texture(lightingMask,UV);
		
	float outline = texture(lightingMask, UV + vec2(-size.x, 0)).a;
	outline += texture(lightingMask, UV).a;
	outline += texture(lightingMask, UV + vec2(0, size.y)).a;
	outline += texture(lightingMask, UV + vec2(size.x, 0)).a;
	outline += texture(lightingMask, UV + vec2(0, -size.y)).a;
	outline += texture(lightingMask, UV + vec2(-size.x, size.y)).a;
	outline += texture(lightingMask, UV + vec2(size.x, size.y)).a;
	outline += texture(lightingMask, UV + vec2(-size.x, -size.y)).a;
	outline += texture(lightingMask, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
		
		
		
	if (outline <= 0.01) {
		COLOR.a = 0.0;
	}
	
}
