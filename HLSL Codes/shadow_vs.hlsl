
//texture and sampler for vertex data
Texture2D texture0 : register(t0);
SamplerState samplerState : register(s0);

// buffer that holds the transformation matrices
cbuffer MatrixBuffer : register(b0)
{
	matrix worldMatrix;
	matrix viewMatrix;
	matrix projectionMatrix;
	matrix lightViewMatrix;
	matrix lightProjectionMatrix;
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
	float3 normal : NORMAL;
    float4 lightViewPos : TEXCOORD1;
};

// Main vertex shader function
OutputType main(InputType input)
{
    OutputType output;

    //doing vertex manipulation as the shadow is formed in ground
    //and it needs to create space for the water using heightmap (texture0).
    float height1 = texture0.SampleLevel(samplerState, input.tex, 0.0).r * (-10.0f);
    
    input.position.xyz += input.normal * height1;
    // Transform the vertex position to screen space using world, view, and projection matrices
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);
    
	// Calculate the position of the vertice as viewed by the light source.
    output.lightViewPos = mul(input.position, worldMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightViewMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix);

    // Pass texture coordinates and normals to the pixel shade
    output.tex = input.tex;
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    return output;
}