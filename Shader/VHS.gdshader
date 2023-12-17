shader_type canvas_item;

uniform float curvature_x_amount : hint_range(3.0, 15.0, 0.01) = float(6.0); 
uniform float curvature_y_amount : hint_range(3.0, 15.0, 0.01) = float(4.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec2 uv_curve(vec2 uv) {
	uv = uv * 2.0 - 1.0;
	vec2 offset = abs(uv.yx) / vec2(curvature_x_amount, curvature_y_amount);
	uv = uv + uv * offset * offset;
	uv = uv * 0.5 + 0.5;
	

	return uv;
}

void fragment(){
	vec4 color = vec4(0);
	vec2 uv = uv_curve(UV);
	vec2 pos = SCREEN_UV;///vec2(512,300);
	float whiteNoise = 9999.0;
	pos.x = pos.x+(rand(vec2(TIME,uv.y))-0.5)/64.0;
	// Jitter the whole picture up and down
	pos.y = pos.y+(rand(vec2(TIME))-0.5)/32.0;
	
	whiteNoise = rand(vec2(floor(pos.y*80.0),floor(pos.x*50.0))+vec2(TIME,0));
	if (whiteNoise > 11.5-30.0*pos.y || whiteNoise < 1.5-5.0*pos.y) {
	//pos.y = 1.0-pos.y; //Fix for upside-down texture
	}else{
		color = vec4(1);
	}
	color = color + (vec4(-0.5)+vec4(rand(vec2(uv.y,TIME)),rand(vec2(uv.y,TIME+1.0)),rand(vec2(uv.y,TIME+2.0)),0))*0.1;
	color = color + texture(SCREEN_TEXTURE,pos);

	COLOR = color;

}


