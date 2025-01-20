// Input textures and sampler state
Texture2D texture0 : register(t0);
Texture2D texture1 : register(t1);
SamplerState sampler0 : register(s0);

// buffer for lighting information
cbuffer LightBuffer : register(b0)
{
	float4 diffuseColour;
	float3 lightDirection;
	float padding;
};

// input data passed from the vertex shader
struct InputType
{
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float3 normal : NORMAL;
};

// Calculate lighting intensity based on direction and normal. Combine with light colour.
float4 calculateLighting(float3 lightDirection, float3 normal, float4 diffuse)
{
	float intensity = saturate(dot(normal, lightDirection));
	float4 colour = saturate(diffuse * intensity);
	return colour;
}

// Main pixel shader function
float4 main(InputType input) : SV_TARGET
{
	float4 textureColour;
	float4 textureColour1;
	float4 lightColour;

	// Sample the texture. Calculate light intensity and colour, return light*texture for final pixel colour.
	textureColour = texture0.Sample(sampler0, input.tex);
    textureColour1 = texture1.Sample(sampler0, input.tex);
	
	//if secondary texture has more blue channel than other then blend together, 
	//to identify water texture and blending water reflection
	//else (not water body/texture) do default texture and light calculations.
	if(textureColour1.b > textureColour1.r && textureColour1.b > textureColour1.g)
    {
        textureColour.a = 1.0f;
        textureColour1.a = 1.0f;
        lightColour = calculateLighting(normalize(lightDirection), input.normal, diffuseColour);
        float4 blendedTexture = lerp(textureColour1, textureColour, 0.25);
        return blendedTexture ;
    }
    else
	{
		float intensity = saturate(dot(input.normal, lightDirection));
        return intensity * textureColour;
    }
}



