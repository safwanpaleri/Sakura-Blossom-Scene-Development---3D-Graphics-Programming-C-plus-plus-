// Texture resource for the scene and sampler state
Texture2D sceneTexture : register(t0);
SamplerState samplerState : register(s0);

// Gaussian weights for blur
float GaussianWeight[5] = { 0.05, 0.15, 0.6, 0.15, 0.05 };

// buffer to store lighting and blur parameters
cbuffer lightBuffer : register(b0)
{
    float2 sunPosition;
    float intensity;
    float darkenAmount;
    float blurRadius;
    float2 textureSize;
    float padding;
};

// Input for the vertex shader output
struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 worldPosition : TEXCOORD1;
    float3 normal : NORMAL;
};

// Function to apply Gaussian blur to a texture
float3 ApplyBlur(float2 texCoord)
{
    float3 blurredColor = float3(0, 0, 0);

    // Calculate texel size for scaling blur offsets based on texture resolution.
    float2 texelSize = 1.0 / textureSize;

    // Horizontal blur
    for (int i = -4; i <= 4; ++i)
    {
        float2 offset = float2(i, 0) * texelSize * blurRadius; 
        blurredColor += sceneTexture.Sample(samplerState, texCoord + offset).rgb * GaussianWeight[abs(i)];
    }

    // Vertical blur
    float3 tempBlur = float3(0, 0, 0);
    for (int j = -4; j <= 4; ++j)
    {
        float2 offset = float2(0, j) * texelSize * blurRadius;
        tempBlur += sceneTexture.Sample(samplerState, texCoord + offset).rgb * GaussianWeight[abs(j)];
    }

    // Combine horizontal and vertical blur results and scale for final blending.
    blurredColor = (blurredColor + tempBlur) * 0.8;

    return blurredColor;
}

// Main pixel shader function
float4 main(InputType input) : SV_TARGET
{
    // Sample the texture at the given coordinates.
    float4 color = sceneTexture.Sample(samplerState, input.tex); 

    // Calculate a diagonal gradient based on the sun's position.
    float gradient = dot(input.tex - sunPosition, float2(0.5, 0.05));
    float mask = saturate(gradient * 2.0 - 1.0);

    // Brighten lit areas based on the mask and intensity.
    float3 litColor = color.rgb * (1.0 + intensity * mask);

    // Darken shadowed areas based on the mask and darkenAmount.
    float3 darkColor = color.rgb * (1.0 + darkenAmount * (1.0 - mask));

    // Apply blur to the darkened areas where the mask is below a threshold (e.g., 0.5).
    if (mask < 0.5)
    {
        darkColor = ApplyBlur(input.tex);
    }

    // Blend the lit and dark colors based on the mask value.
    float3 finalColor = lerp(darkColor, litColor, mask);

    return float4(finalColor, color.a); // Return the final blended color with the original alpha.
}
