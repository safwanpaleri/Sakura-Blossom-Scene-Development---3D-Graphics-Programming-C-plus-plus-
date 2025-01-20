// texture vertex shader
// Basic shader for rendering textured geometry

//buffer for passing transformation matrices to the shader
cbuffer MatrixBuffer : register(b0)
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
};

// Input for vertex data
struct InputType
{
	float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

// Output for transformed vertex data
struct OutputType
{
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
    float3 worldPosition : TEXCOORD1;
    float3 normal : NORMAL;
};


// Main shader function
OutputType main(InputType input)
{
	OutputType output;
	
    input.position.w = 0.5;
	
	output.position = mul(input.position, worldMatrix);
	output.position = mul(output.position, viewMatrix);
	output.position = mul(output.position, projectionMatrix);
	
    output.worldPosition = mul(input.position, worldMatrix).xyz;
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);
	output.tex = input.tex;
	
	return output;
}