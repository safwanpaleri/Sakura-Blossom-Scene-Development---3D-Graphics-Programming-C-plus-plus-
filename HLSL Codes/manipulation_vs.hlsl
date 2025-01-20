//SamplerState and texture variable to save
SamplerState samplerState : register(s0);
Texture2D heightMap : register(t0);

// Standard issue vertex shader, apply matrices, pass info to pixel shader
cbuffer MatrixBuffer : register(b0)
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
};

// Time buffer for store values related to effect
cbuffer TimeBuffer : register(b1)
{
    float time;
    float amplitude;
    float frequency;
    float speed;
};

// Input from the vertex buffer
struct InputType
{
	float4 position : POSITION;
	float2 tex : TEXCOORD0;
	float3 normal : NORMAL;
};

// Output for the pixel shader
struct OutputType
{
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float3 normal : NORMAL;
};

// Main vertex shader function
OutputType main(InputType input)
{
	OutputType output;
	
    // Sample the red channel of the height map to determine height displacement
    if (heightMap.SampleLevel(samplerState, input.tex, 0.0).r)
    {
        //decrease the height by 10.0f if along the red channel
        float height1 = heightMap.SampleLevel(samplerState, input.tex, 0.0).r * (-10.0f);
        output.tex = input.tex;
        input.position.xyz += input.normal * height1;
        output.position = mul(input.position, worldMatrix);
        output.position = mul(output.position, viewMatrix);
        output.position = mul(output.position, projectionMatrix);
        output.normal = mul(input.normal, (float3x3) worldMatrix);
        output.normal = normalize(output.normal);

        return output;
    }
    // If the blue channel is sampled, apply wave-based motion
    else if (heightMap.SampleLevel(samplerState, input.tex, 0.0).b)
    {
        input.position.y += sin(input.position.x * frequency + time * speed) * amplitude;
        input.position.z += cos(input.position.x * frequency + time * speed) * amplitude * 0.5;
        output.position = mul(input.position, worldMatrix);
        output.position = mul(output.position, viewMatrix);
        output.position = mul(output.position, projectionMatrix);
        
        output.tex = input.tex;
        
        output.normal = mul(input.normal, (float3x3) worldMatrix);
        output.normal = normalize(output.normal);

        return output;
    }
    //if normal map, then do default vertex transformation.
    else
    {
        output.position = mul(input.position, worldMatrix);
        output.position = mul(output.position, viewMatrix);
        output.position = mul(output.position, projectionMatrix);
        
        output.tex = input.tex;
        
        output.normal = mul(input.normal, (float3x3) worldMatrix);
        output.normal = normalize(output.normal);

        return output;
    }
    
}