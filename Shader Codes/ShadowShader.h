// Light shader.h
// Basic single light shader setup
#ifndef _SHADOWSHADER_H_
#define _SHADOWSHADER_H_

#include "DXF.h"
#include "SingleLight.h"

using namespace std;
using namespace DirectX;

// ShadowShader: A shader class for handling shadows with single light sources.
class ShadowShader : public BaseShader
{
private:
	// matrices buffer struct for transforming vertices and handling light space.
	struct MatrixBufferType
	{
		XMMATRIX world;
		XMMATRIX view;
		XMMATRIX projection;
		XMMATRIX lightView;
		XMMATRIX lightProjection;
	};

	// matrices buffer light for parameters of light sources.
	struct LightBufferType
	{
		XMFLOAT4 ambient;
		XMFLOAT4 diffuse;
		XMFLOAT3 direction;
		float padding;
	};

public:

	// Constructor
	ShadowShader(ID3D11Device* device, HWND hwnd);
	// Destructor
	~ShadowShader();

	//Sets the shader's input parameters for rendering.
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX &world, const XMMATRIX &view, const XMMATRIX &projection, ID3D11ShaderResourceView* texture, ID3D11ShaderResourceView*depthMap, SingleLight* light, ID3D11ShaderResourceView* heightmaptexture);

private:
	//Sets the shader's input parameters for rendering.
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	//buffer and sampler pointers
	ID3D11Buffer* matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11SamplerState* sampleState2;
	ID3D11SamplerState* sampleStateShadow;
	ID3D11Buffer* lightBuffer;
};

#endif