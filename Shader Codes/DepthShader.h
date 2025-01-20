#pragma once

#include "DXF.h" 

using namespace std;
using namespace DirectX;  

class DepthShader : public BaseShader
{
public:
    // Constructor: Initializes the DepthShader object and loads the shaders.
    DepthShader(ID3D11Device* device, HWND hwnd);

    // Destructor: Cleans up any resources allocated by the shader.
    ~DepthShader();

    // Sets the shader parameters before rendering.
    void setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& world, const XMMATRIX& view, const XMMATRIX& projection);

private:
    // Initializes the vertex and pixel shaders by loading compiled shader files.
    void initShader(const wchar_t* vs, const wchar_t* ps);

private:
    // Buffer for storing transformation matrices (world, view, projection).
    ID3D11Buffer* matrixBuffer; 
};
