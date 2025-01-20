#pragma once

#include "DXF.h"

using namespace std;
using namespace DirectX;

// Shader class for handling custom manipulation effects
class ManipulationShader : public BaseShader
{
private:
	// Structure for storing light data
	struct LightBufferType
	{
		XMFLOAT4 diffuse;
		XMFLOAT3 direction;
		float padding;
	};

	// Structure for storing time-dependent manipulation
	struct TimeBufferType
	{
		float time;
		float frequency;
		float amplitude;
		float speed;
	};

public:
	// Constructor
	ManipulationShader(ID3D11Device* device, HWND hwnd);
	// Destructor
	~ManipulationShader();

	// Sets the shader parameters before rendering
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture, ID3D11ShaderResourceView* heightmaptexture, Timer* timer, float* amplitude, float* frequency, float* speed, Light* light, ID3D11ShaderResourceView* texture2);

private:
	// Initializes the shaders and associated resources
	void initShader(const wchar_t* cs, const wchar_t* ps);

private:
	// Buffers and states for managing shader data
	ID3D11Buffer* matrixBuffer;
	ID3D11Buffer* timeBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11SamplerState* sampleState2;
	ID3D11Buffer* lightBuffer;

	// Variable to track time
	float time;
};

