shader_type canvas_item;
uniform vec3 color = vec3(1.0,1.0,0.2);
uniform int OCTAVES = 4;

float rand(vec2 coord){
	return fract(sin(dot(coord,vec2(19.421,78.123))*1000.0)*1000.0);
}

//uniform sampler2D noise;

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i+vec2(0.0,0.0));
	float b = rand(i+vec2(1.0,0.0));
	float c = rand(i+vec2(0.0,1.0));
	float d = rand(i+vec2(1.0,1.0));
	
	vec2 cube= f*f*(3.0-2.0*f);
	
	return mix(a,b,cube.x)+(c-a)*cube.y*(1.0-cube.x)+(d-b)*cube.x*cube.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord)*scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment(){
	vec2 coord = vec2(UV*2.0);
	
	vec2 motion = vec2(fbm(coord+vec2(TIME*0.2,TIME*-0.2)));
	float alpha = fbm(coord+vec2(TIME*0.2,TIME*0.1) + motion);
	float final = fbm(coord);
	
	COLOR = vec4(color,alpha);
}