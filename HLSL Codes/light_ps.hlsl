// Light Pixel Shader
// Implements diffuse lighting, shadow mapping, and texturing for multiple lights.
Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

Texture2D depthMapTexture : register(t1);
SamplerState shadowSampler : register(s1);

//Stores lighting parameters for multiple lights, including direction and color.
cbuffer LightBuffer : register(b0)
{
    float4 ambient[3];
    float4 diffuse[3];
    float3 direction; 
    float specularPower;
    float4 specular;
    float3 position[2];
    float padding[2];
};

//Data passed from the vertex shader.
struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
    float3 normal : NORMAL;
    float3 worldPosition : TEXCOORD1;
    float3 viewVector : TEXCOORD2;
    float4 lightViewPos : TEXCOORD3;
};

// Checks if the given UV coordinates are within the valid range of [0,1].
bool hasDepthData(float2 uv)
{
    if (uv.x < 0.f || uv.x > 1.f || uv.y < 0.f || uv.y > 1.f)
    {
        return false;
    }
    return true;
}

// Determines if the pixel is in shadow by comparing depths in the shadow map.
bool isInShadow(Texture2D tex, float2 texCoord, float4 lightViewPosition, float padding)
{
    float shadowDepthValue = tex.Sample(shadowSampler, texCoord).r;
    float lightDepthValue = lightViewPosition.z / lightViewPosition.w;
    lightDepthValue -= padding;

    // Return true if the pixel is in shadow, false otherwise.
    return lightDepthValue >= shadowDepthValue;
}

// Converts light view position to projective texture coordinates for shadow mapping.
float2 getProjectiveCoords(float4 lightViewPosition)
{
    float2 projTex = lightViewPosition.xy / lightViewPosition.w;
    projTex *= float2(0.5, -0.5); 
    projTex += float2(0.5f, 0.5f);
    return projTex;
}

// Calculates diffuse lighting intensity and color based on the light direction and surface normal.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 ldiffuse)
{
    float intensity = saturate(dot(normal, lightDirection)); 
    return saturate(ldiffuse * intensity);
}

// Calculates specular lighting based on the light direction, normal, view vector, and specular properties.
float4 calculateSpecular(float3 lightDirection, float3 normal, float3 viewVector, float4 specularColor, float specularPower)
{
    float3 halfway = normalize(lightDirection + viewVector);
    float specularIntensity = pow(max(dot(normal, halfway), 0.0f), specularPower);
    return saturate(specularColor * specularIntensity); 
}

// Main pixel shader function
float4 main(InputType input) : SV_TARGET
{
    float shadowPadding = 0.005f;
    float4 Scolour = float4(0.f, 0.f, 0.f, 1.0f); 

    // Compute projected texture coordinates for shadow mapping.
    float2 pTexCoord = getProjectiveCoords(input.lightViewPos);

    // Check if pixel is in shadow.
    if (hasDepthData(pTexCoord))
    {
        if (!isInShadow(depthMapTexture, pTexCoord, input.lightViewPos, shadowPadding))
        {
            Scolour = calculateLighting(-direction, input.normal, diffuse[0]); // Add lighting if not in shadow.
        }
    }

    // Sample the object's texture.
    float4 textureColour = texture0.Sample(sampler0, input.tex);

    // Compute light direction vectors for point lights.
    float3 lightVector0 = normalize(position[0] - input.worldPosition);
    float3 lightVector1 = normalize(position[1] - input.worldPosition);

    // Compute lighting contributions from each light source.
    float4 lightColour0 = ambient[0] + calculateLighting(lightVector0, input.normal, diffuse[0]);
    float4 lightColour1 = ambient[1] + calculateLighting(lightVector1, input.normal, diffuse[1]);
    float4 lightColour2 = ambient[2] + calculateLighting(normalize(direction), input.normal, diffuse[2]);

    // Combine lighting contributions and apply the texture color.
    return (lightColour0 + lightColour1 + lightColour2 + Scolour) * textureColour;
}
