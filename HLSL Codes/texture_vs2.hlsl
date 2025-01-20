// texture vertex shader
// Basic shader for rendering textured geometry

// buffer to store transformation matrices
cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

// buffer to store camera properties
cbuffer CameraBuffer : register(b2)
{
    float3 cameraPosition;
    float padding;
};

// Input for vertex data
struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

// Output for the vertex shader to pass data to the pixel shader
struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
};

// buffer to store time properties
cbuffer TimeBuffer : register(b1)
{
    float time;
    float amplitude;
    float frequency;
    float speed;
};

// Main vertex shader function
OutputType main(InputType input)
{
    OutputType output;
	
    input.position.w = 0.5;
    //updating x and y axis over time, giving a simulation effect
    input.position.x += sin(input.position.x * frequency + time * speed) * amplitude;
    input.position.y += cos(input.position.x * frequency + time * speed) * amplitude * 0.5f;
	
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

	// Store the texture coordinates for the pixel shader.
    output.tex = input.tex;
    

    return output;
}