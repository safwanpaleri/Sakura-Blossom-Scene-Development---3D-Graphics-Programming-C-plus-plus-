#pragma once

#include "BaseShader.h"
#include "DXF.h"

using namespace std;
using namespace DirectX;

class TextureShader : public BaseShader
{
private:
	struct TimeBufferType
	{
		float time;
		float frequency;
		float amplitude;
		float speed;
	};
public:
	TextureShader(ID3D11Device* device, HWND hwnd);
	~TextureShader();
	//Lab 2 Submission Task
	//Added texture1 to the function
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture0);
	//void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture0, Timer* timer, float amplitude, float frequency, float speed, const Light* light = nullptr);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* timeBuffer;

	float time;
};

