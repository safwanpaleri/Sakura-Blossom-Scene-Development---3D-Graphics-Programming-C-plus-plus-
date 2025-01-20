//Constant buffer used to store transformation matrices.
cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
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
    float4 depthPosition : TEXCOORD0;
};

// Main vertex shader function
OutputType main(InputType input)
{
    OutputType output;

    // Transform the vertex position from object space to clip space.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

    // Store the clip-space position in depthPosition for further depth calculations.
    output.depthPosition = output.position;

    // Return the transformed vertex data to the rasterizer.
    return output;
}
