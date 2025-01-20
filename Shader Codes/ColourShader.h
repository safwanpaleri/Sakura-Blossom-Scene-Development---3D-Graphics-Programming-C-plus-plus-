// ColourShader.h
// Simple shader example header file.
#ifndef _COLOURSHADER_H_
#define _COLOURSHADER_H_

//includes
#include "../DXFramework/BaseShader.h"
#include "DXF.h"                      

using namespace std;
using namespace DirectX;

class ColourShader : public BaseShader
{
private:
    

public:
    // Constructor: Initializes the shader.
    ColourShader(ID3D11Device* device, HWND hwnd);

    // Destructor: Cleans up resources.
    ~ColourShader();

    // Function to set shader parameters 
    void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection, Timer* timer, float amplitude, float frequency, float speed);

private:
    // Function to initialize the vertex and pixel shaders.
    void initShader(const wchar_t* vs, const wchar_t* ps);

private:
    // Buffer for storing world, view, and projection matrices.
    ID3D11Buffer* matrixBuffer;
};

#endif
