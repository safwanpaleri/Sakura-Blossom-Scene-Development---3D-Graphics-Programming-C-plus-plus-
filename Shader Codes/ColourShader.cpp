#include "colourshader.h"

ColourShader::ColourShader(ID3D11Device* device, HWND hwnd) : BaseShader(device, hwnd)
{
    // Initialize the shader by loading the vertex and pixel shaders.
    initShader(L"colour_vs.cso", L"colour_ps.cso");
}

// Destructor: Cleans up allocated resources.
ColourShader::~ColourShader()
{
    // Release the matrix constant buffer.
    if (matrixBuffer)
    {
        matrixBuffer->Release();
        matrixBuffer = 0;
    }

    // Release the input layout.
    if (layout)
    {
        layout->Release();
        layout = 0;
    }

    // Call the destructor of the base class to release any additional resources.
    BaseShader::~BaseShader();
}

// Initializes the shaders and sets up constant buffers.
void ColourShader::initShader(const wchar_t* vsFilename, const wchar_t* psFilename)
{
    D3D11_BUFFER_DESC matrixBufferDesc;

    // Load and compile the vertex and pixel shaders.
    loadColourVertexShader(vsFilename);
    loadPixelShader(psFilename);

    // Configure the matrix buffer description for dynamic usage.
    matrixBufferDesc.Usage = D3D11_USAGE_DYNAMIC;                  
    matrixBufferDesc.ByteWidth = sizeof(MatrixBufferType);         
    matrixBufferDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;       
    matrixBufferDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;     
    matrixBufferDesc.MiscFlags = 0;                                
    matrixBufferDesc.StructureByteStride = 0;                      

    // Create the matrix buffer with the specified description.
    renderer->CreateBuffer(&matrixBufferDesc, NULL, &matrixBuffer);
}

// Sets parameters for the shader, including matrices and time-related data.
void ColourShader::setShaderParameters(ID3D11DeviceContext* deviceContext, const XMMATRIX& worldMatrix, const XMMATRIX& viewMatrix, const XMMATRIX& projectionMatrix, Timer* timer, float amplitude, float frequency, float speed)
{
    D3D11_MAPPED_SUBRESOURCE mappedResource; 
    MatrixBufferType* dataPtr;               
    XMMATRIX tworld, tview, tproj;           

    // Transpose the matrices for the HLSL shader (row-major to column-major format).
    tworld = XMMatrixTranspose(worldMatrix);
    tview = XMMatrixTranspose(viewMatrix);
    tproj = XMMatrixTranspose(projectionMatrix);

    // Lock the matrix buffer for writing.
    deviceContext->Map(matrixBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);
    dataPtr = (MatrixBufferType*)mappedResource.pData; 

    // Copy the transposed matrices into the buffer.
    dataPtr->world = tworld;
    dataPtr->view = tview;
    dataPtr->projection = tproj;

    // Unlock the matrix buffer to apply the changes.
    deviceContext->Unmap(matrixBuffer, 0);

    // Set the updated matrix buffer into the vertex shader.
    deviceContext->VSSetConstantBuffers(0, 1, &matrixBuffer);
}
