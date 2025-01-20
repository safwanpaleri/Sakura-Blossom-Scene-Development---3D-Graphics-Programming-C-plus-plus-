// Constant buffer to pass matrix data used to transform the vertex positions.
cbuffer MatrixBuffer : register(b0)
{
    matrix worldMatrix;
    matrix viewMatrix;
    matrix projectionMatrix;
};

//Input data passed to the vertex shader.
struct InputType
{
    float4 position : POSITION;
    float2 tex : TEXCOORD0;
};

// Output data sent to the pixel shader.
struct OutputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
};

//Main function
OutputType main(InputType input)
{
    OutputType output;

    // Assign input position.w
    input.position.w = 0.5;

    // Passing position to pixel shader after converting to screenspace.
    output.position = mul(input.position, worldMatrix);
    output.position = mul(output.position, viewMatrix);
    output.position = mul(output.position, projectionMatrix);

    // Pass the texture coordinates directly to the output.
    output.tex = input.tex;

    return output;
}
