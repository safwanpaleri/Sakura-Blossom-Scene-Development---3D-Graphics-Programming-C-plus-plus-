// buffer used to store transformation matrices.
cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix; 
    matrix viewMatrix; 
    matrix projectionMatrix;
    matrix lightViewMatrix;
    matrix lightProjectionMatrix;
};

// buffer used to store the camera's position.
cbuffer CameraBuffer : register(b1)
{
    float3 cameraPosition;
    float padding;
};

// input data passed from the vertex buffer.
struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

//output data passed to the pixel shader.
struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
    float4 lightViewPos : TEXCOORD3;
};

// Main vertex shader function
OutputType main(InputType input)
{
    OutputType output;

    // Set the w component of the input position
    input.position.w = 0.5;

    // Transform the vertex position through the world, view, and projection matrices.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

    // Calculate the vertex position in light view-projection space for shadow mapping.
    output.lightViewPos = mul(input.position, worldMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightViewMatrix);
    output.lightViewPos = mul(output.lightViewPos, lightProjectionMatrix);

    // Pass the texture coordinates to the pixel shader.
    output.tex = input.tex;

    // Transform the normal vector by the world matrix and normalize it.
    output.normal = mul(input.normal, (float3x3) worldMatrix);
    output.normal = normalize(output.normal);

    // Calculate the vertex position in world space.
    output.worldPosition = mul(input.position, worldMatrix).xyz;

    // Calculate the vector from the camera to the vertex and normalize it.
    output.viewVector = cameraPosition.xyz - output.worldPosition.xyz;
    output.viewVector = normalize(output.viewVector); 

    // Return the transformed vertex data to the rasterizer.
    return output;
}
