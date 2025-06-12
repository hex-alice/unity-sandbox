#include "CelesToonShader_variable.hlsl"
#include "CelesToonShader_utility.hlsl"

Varyings vert(Attributes IN)
{
    Varyings OUT;
    VertexPositionInputs vertexInput = GetVertexPositionInputs(IN.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(IN.normalOS, IN.tangentOS);
    
    float3 positionWS = vertexInput.positionWS;
    float3 positionVS_Z = vertexInput.positionVS.z;
    float3 normalWS = vertexNormalInput.normalWS;

    // Get Camera FOV (simple but slow)
    // Add to properties
    float t = unity_CameraProjection._m11;
    float rad2Deg = 180 / PI;
    float fov = atan(1.0f / t) * 2.0 * rad2Deg;

    float cameraMulFix;
    if (unity_OrthoParams.w == 0)
    {
        cameraMulFix = abs(positionVS_Z);
        cameraMulFix = saturate(cameraMulFix);
        cameraMulFix *= fov;
    }
    else
    {
        float orthoSize = abs(unity_OrthoParams.y);
        orthoSize = saturate(orthoSize);
        cameraMulFix = orthoSize * 50;
    }

    cameraMulFix *= 0.00005;
    
    float outlineExpandAmount = _OutlineWidth * cameraMulFix;
    positionWS = positionWS + normalWS * outlineExpandAmount;
    
    OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
    OUT.normalWS = vertexNormalInput.normalWS;

    OUT.positionCS = TransformWorldToHClip(positionWS);
    OUT.positionWS = TransformWorldToObject(positionWS);

    return OUT;
}

half4 frag(Varyings IN) : SV_Target
{
    half dx = IN.positionWS.x * 0.5 + 0.5;
    half dy = IN.positionWS.y * 0.5;
    dx += Random(IN.uv * 200) * 0.1;
    half dissolveValue = Random(IN.positionWS.xy * _DissolveSize);
    half finalAlpha = 1 - step(_DissolveStep, dx);

    return half4(_OutlineColor.rgb, finalAlpha);
}