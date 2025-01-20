#pragma once

#include "BaseShader.h"
#include "DXF.h"
#include "SingleLight.h"

using namespace std;
using namespace DirectX;

class RenderTextureShader : public BaseShader
{
private:
	// Struct to hold light and texture-related data for the shader
	struct LightBufferType
	{
		XMFLOAT2 sunPosition;
		float intensity;
		float darkenAmount;
		float blurRadius;
		XMFLOAT2 textureSize;
		float padding;
		
	};
public:
	// Constructor
	RenderTextureShader(ID3D11Device* device, HWND hwnd);
	// Destructor
	~RenderTextureShader();
	// Sets shader parameters such as transformations, texture, lighting, etc.
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture0, SingleLight* light, float intensity, float darkenAmount, float blurRadius, float texrureWidth, float textureHeight);
	
private:
	// Initializes the shader
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	// buffer holders
	ID3D11Buffer* matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* lightBuffer;

	float time;
};

