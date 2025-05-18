#include "CelesToonShader_variable.hlsl"

// half3 ShadeGI(SurfaceData surfaceData, LightingData lightingData)
// {
//     half3 averageSH = SampleSH(0);
//     averageSH = max(_IndirectLightMinColor, averageSH);

    
// }

half3 ShadeSingleLight(ToonSurfaceData surfaceData, ToonLightingData lightingData, Light light, bool isAdditionalLight)
{
    half3 N = lightingData.normalWS;
    half3 L = light.direction;

    half NoL = dot(N, L);
    half lightAttenuation = 1;

    half litOrShadowArea = smoothstep(0.0, 0.05, NoL);

    return saturate(light.color) * litOrShadowArea;
}

Varyings vert (Attributes IN)
{
    Varyings OUT;

    //UNITY_SETUP_INSTANCE_ID(input);
    //UNITY_TRANSFER_INSTANCE_ID(IN, output);
    //UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

    VertexPositionInputs vertexInput = GetVertexPositionInputs(IN.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(IN.normalOS, IN.tangentOS);

    float3 positionWS = vertexInput.positionWS;
    
    OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
    OUT.normalWS = vertexNormalInput.normalWS;

    OUT.positionCS = TransformWorldToHClip(positionWS);

    return OUT;
}

half4 frag (Varyings IN) : SV_Target
{

    //UNITY_SETUP_INSTANCE_ID(IN);
    //UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

    ToonSurfaceData surfaceData;
    ToonLightingData lightData;

    // Setup Surface Data
    half4 baseMap = tex2D(_BaseMap, IN.uv) * _BaseColor;
    surfaceData.albedo = baseMap.rgb;
    surfaceData.alpha = baseMap.a;

    // Setup Lighting Data
    lightData.positionWS = IN.positionWS.xyz;
    lightData.viewDirectionWS = SafeNormalize(GetCameraPositionWS() - lightData.positionWS);
    lightData.normalWS = normalize(IN.normalWS);

    // Shading
    //half3 indirectResult = ShadeGI(surfaceData, lightingData);
    Light mainLight = GetMainLight();
    half3 mainLightResult = ShadeSingleLight(surfaceData, lightData, mainLight, false);
    half3 finalColor = lerp(baseMap * 0.5, baseMap, mainLightResult);

    return half4(finalColor, surfaceData.alpha);
}