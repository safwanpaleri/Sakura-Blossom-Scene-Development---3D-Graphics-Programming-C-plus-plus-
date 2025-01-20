
//textures and samplers for pixel data
Texture2D shaderTexture : register(t0);
Texture2D depthMapTexture : register(t1);

SamplerState diffuseSampler  : register(s0);
SamplerState shadowSampler : register(s1);

// buffer that holds the light data
cbuffer LightBuffer : register(b0)
{
	float4 ambient;
	float4 diffuse;
	float3 direction;
    float padding;
};


// Input for pixel data
struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
	float3 normal : NORMAL;
    float4 lightViewPos : TEXCOORD1;
};

// Calculate lighting intensity based on direction and normal. Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 diffuse)
{
    float intensity = saturate(dot(normal, lightDirection));
    float4 colour = saturate(diffuse * intensity);
    return colour;
}

// Is the gemoetry in the shadow map
bool hasDepthData(float2 uv)
{
    if (uv.x < 0.f || uv.x > 1.f || uv.y < 0.f || uv.y > 1.f)
    {
        return false;
    }
    return true;
}

// Determine if a point is in shadow based on depth comparison.
bool isInShadow(Texture2D tex, float2 texCoord, float4 lightViewPosition, float padding)
{
    // Sample the shadow map (get depth of geometry)    
	// Calculate the depth from the light.
    float depthValue = tex.Sample(shadowSampler, texCoord).r;
    float lightDepthValue = lightViewPosition.z / lightViewPosition.w;
    lightDepthValue -= padding;

	// Compare the depth of the shadow map value and the depth of the light to determine whether to shadow or to light this pixel.
    if (lightDepthValue < depthValue)
    {
        return false;
    }
    return true;
}

// Convert light-space position to projected texture coordinates
float2 getProjectiveCoords(float4 lightViewPosition)
{
    // Calculate the projected texture coordinates.
    float2 projTex = lightViewPosition.xy / lightViewPosition.w;
    projTex *= float2(0.5, -0.5);
    projTex += float2(0.5f, 0.5f);
    return projTex;
}

// Main pixel shader function.
float4 main(InputType input) : SV_TARGET
{
    float4 lightColor = float4(0.f, 0.f, 0.f, 1.0f);
    float4 textureColour = shaderTexture.Sample(diffuseSampler, input.tex);

	// Calculate the projected texture coordinates.
    float2 pTexCoord = getProjectiveCoords(input.lightViewPos);
	
    if (hasDepthData(pTexCoord))
    {
        if (!isInShadow(depthMapTexture, pTexCoord, input.lightViewPos, 0.005f))
        {
            // is NOT in shadow, therefore light
            lightColor = calculateLighting(-direction, input.normal, diffuse);
        }
    }
    
    lightColor = saturate(lightColor + ambient);
    return saturate(lightColor) * textureColour;
}