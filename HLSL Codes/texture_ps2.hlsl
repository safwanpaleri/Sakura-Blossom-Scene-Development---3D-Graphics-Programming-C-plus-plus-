// Light pixel shader
// Calculate diffuse lighting for a single directional light (also texturing)

Texture2D texture0 : register(t0);
SamplerState sampler0 : register(s0);

struct InputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
};


float4 main(InputType input) : SV_TARGET
{
	// Sample the texture. Calculate light intensity and colour, retur	n light*texture for final pixel colour.
    float4 textureColour = texture0.Sample(sampler0, input.tex);

    //combine all the lights and multiply with texture color
    return textureColour;
}



