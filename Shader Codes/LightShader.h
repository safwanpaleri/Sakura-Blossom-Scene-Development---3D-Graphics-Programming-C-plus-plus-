#pragma once

#include "DXF.h"

using namespace std;
using namespace DirectX;

class LightShader : public BaseShader
{
private:
	// Structure to hold matrix data for transformations.
	struct MatrixBufferType
	{
		XMMATRIX world;
		XMMATRIX view;
		XMMATRIX projection;
		XMMATRIX lightView;
		XMMATRIX lightProjection;
	};

	// Structure to hold light-related data.
	struct LightBufferType
	{
		XMFLOAT4 ambient[3];
		XMFLOAT4 diffuse[3];
		XMFLOAT3 direction;
		float specularPower;
		XMFLOAT4 specular;
		XMFLOAT3 position[2];
		float padding[2];
	};

public:
	//constructor
	LightShader(ID3D11Device* device, HWND hwnd);

	//Destructor
	~LightShader();

	//Sets shader parameters before rendering.
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX &world, const XMMATRIX &view, const XMMATRIX &projection, ID3D11ShaderResourceView* texture, Light* light, ID3D11ShaderResourceView* depthMap = nullptr);

private:
	//Initializes the shader, loading and compiling the vertex and pixel shader files.
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer * matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* lightBuffer;
};

