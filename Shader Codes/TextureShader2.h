#pragma once

#include "BaseShader.h"
#include "DXF.h"

using namespace std;
using namespace DirectX;

class TextureShader2 : public BaseShader
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
	TextureShader2(ID3D11Device* device, HWND hwnd);
	~TextureShader2();
	void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, ID3D11ShaderResourceView* texture0, Timer* timer, float amplitude, float frequency, float speed);

private:
	void initShader(const wchar_t* vs, const wchar_t* ps);

private:
	ID3D11Buffer* matrixBuffer;
	ID3D11SamplerState* sampleState;
	ID3D11Buffer* timeBuffer;
	ID3D11Buffer* lightBuffer;

	float time;
};

