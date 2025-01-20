// Texture resource in the pixel shader.
Texture2D texture0 : register(t0);

// Sampler state for controlling how the texture is sampled (e.g., filtering, addressing modes).
SamplerState Sampler0 : register(s0);

// Input structure for the pixel shader, containing data passed from the vertex shader.
struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
};

// Main function
float4 main(InputType input) : SV_TARGET
{
    // Returns a fixed RGBA color value rose shade.
    return float4(1.39f, 0.58f, 0.92f, 1.0f);
}
