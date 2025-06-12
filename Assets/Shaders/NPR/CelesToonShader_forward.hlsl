#include "CelesToonShader_variable.hlsl"
#include "CelesToonShader_utility.hlsl"

half3 ShadeSingleLight(ToonSurfaceData surfaceData, ToonLightingData lightingData, Light light, bool isAdditionalLight)
{
    half3 N = lightingData.normalWS;
    half3 L = light.direction;

    half NoL = dot(N, L);
    half lightAttenuation = 1;

    NoL = saturate(NoL);
    half t1 = _ShadowBand1;
    half t2 = _ShadowBand2;
    
    half darkShadow = step(NoL, t1);
    half midShadow = step(t1, NoL) * step(NoL, t2);
    half lit = step(t2, NoL);
    
    half litOrShadowArea = smoothstep(_ShadowMinValue, _ShadowMaxValue, NoL);

    float ramp = 4.0;
    //litOrShadowArea = Ramp(litOrShadowArea, ramp);
    
    //half litOrShadowArea = lit + (midShadow * 0.5) + (darkShadow * 0); 
    litOrShadowArea *= surfaceData.occlusion;

    return saturate(light.color) * litOrShadowArea;
}

half3 ShadeEmissive(ToonSurfaceData surfaceData, ToonLightingData lightingData)
{
    half3 emissiveColor = lerp(surfaceData.emission, surfaceData.emission * surfaceData.albedo, _EmissiveMulBaseColor);
    return emissiveColor;
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
    OUT.positionVS = vertexInput.positionVS;

    OUT.positionCS = TransformWorldToHClip(positionWS);
    OUT.positionWS = TransformObjectToWorld(positionWS);

    return OUT;
}

half4 frag (Varyings IN) : SV_Target
{

    //UNITY_SETUP_INSTANCE_ID(IN);
    //UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

    ToonSurfaceData surfaceData;
    ToonLightingData lightData;

    // Setup Surface Data
    half4 baseMap = TEX(_BaseMap, IN.uv) * _BaseColor;
    half4 mainTex = lerp(baseMap, _BaseColor, _UseBaseColor);
    surfaceData.albedo = mainTex.rgb;
    surfaceData.alpha = mainTex.a;
    float3 emissiveMap = tex2D(_EmissiveMap, IN.uv).rgb;
    float emissiveMask = dot(emissiveMap, _EmissiveMapChannelMask);
    float3 emission = lerp(0.0, _EmissiveColor, emissiveMask);
    surfaceData.emission = lerp(0, emission, _EnableEmission);
    
    //occlusion
    half occlusionValue = dot(tex2D(_OcclusionMap, IN.uv), _OcclusionMapChannelMask);
    occlusionValue = lerp(1, occlusionValue, _OcclusionStrength);
    occlusionValue = InverseLerpClamp(_OcclusionRemapStart, _OcclusionRemapEnd, occlusionValue);
    surfaceData.occlusion = lerp(1, occlusionValue, _EnableOcclusion);
 
    // Setup Lighting Data
    lightData.positionWS = IN.positionWS.xyz;
    lightData.viewDirectionWS = SafeNormalize(GetCameraPositionWS() - lightData.positionWS); // EYEDIRECTION
    lightData.normalWS = normalize(IN.normalWS);

    half3 emissive = ShadeEmissive(surfaceData, lightData);

    // Shading
    //half3 indirectResult = ShadeGI(surfaceData, lightingData);
    Light mainLight = GetMainLight();
    half3 mainLightResult = ShadeSingleLight(surfaceData, lightData, mainLight, false);

    float2 uv = IN.uv;
    
    float3 P = IN.positionWS;
    float3 N = IN.normalWS;
    float3 uN = normalize(N);
    
    float3 C = GetCameraPositionWS();
    float3 uC = normalize(C);
    float3 view = IN.positionWS;
    
    float3 L = mainLight.direction;
    float3 uL = normalize(L);
    
    float3 V = SafeNormalize(C - P);
    float3 H = SafeNormalize(V + L);
    float3 R = reflect(float3(-L), N);

    // Shadow Map
    half3 shadowMap = tex2D(_ShadowMap, uv).rgb;
    half shadowMask = dot(tex2D(_ShadowMask, uv).rgb, _ShadowMaskChannel);
    shadowMask = step(_ShadowMaskStepValue, shadowMask);
    
    // Highlight
    half3 highlightMap = TEX(_HighlightMap, uv).rgb;
    half highlightValue = dot(highlightMap, _HighlightMaskChannel);
    
    half3 baseWithShadow = lerp(shadowMap, mainTex, shadowMask);
    half3 baseWithHighlightShadow = baseWithShadow + highlightValue * _HighlightIntensity;

    half3 baseColor = lerp(baseWithShadow, baseWithHighlightShadow, _UseHighlight);
    baseColor = lerp(mainTex, baseColor, _UseShadowMap);
    
    // Stylized Shadow
    //float2 centeredUV = frac(IN.uv * 100    ) * 2.0 - 1.0;
    //float dist = length(centeredUV);  // 0 in center, up to ~1.414 in corners
    //float band = 1 - step(0.5, dist); // or smoothstep for softness
    //float shadowCoord = dot(N, L);
    //float stripe = step(0.5, frac(shadowCoord * 2));
    
    //float3 stylizedShadow = mainLightResult * band;
    //mainLightResult += stylizedShadow;
    
    // Main
    half3 ambientWithMap = lerp(shadowMap, baseColor, mainLightResult);
    half3 ambientWithIntensity = lerp(baseColor * _ShadowIntensity, baseColor, mainLightResult);
    half3 ambient = lerp(ambientWithIntensity, ambientWithMap, _UseShadowMap) * _AmbientIntensity * mainLight.color;

    // Specular
    float phongIntensity = saturate(dot(uN, H));
    
    float3 metallicMap = tex2D(_MetallicMap, uv).rgb;
    float3 roughnessMap = tex2D(_RoughnessMap, uv).rgb;
    float specularMap = saturate(dot(tex2D(_SpecularMap, uv).rgb, _SpecularMaskChannel));
    
    //float3 specularColor = lerp(float3(1, 1, 1), ambient, metallicMap);
    float lambertSpecularValue = saturate(dot(R, V));
    float useLambert = lerp(phongIntensity, lambertSpecularValue, _UseLambert);
    float specularIntensity = pow(phongIntensity, _SpecularPower);
    
    float level = 3.0;
    float3 specular = floor(specularIntensity * level) / (level - 1.0);
    specular = specular * _SpecularIntensity * specularMap;
    //specular *= band;
    //half3 s = lerp(half3(0.4, 0.5, 0.6), ambient * diffuse, metallicMap);

    // Rimlight (Fresnel)
    half3 VdotN = saturate(dot(V, uN));
    half3 rimlightIntensity = 1 - VdotN;
    half3 rimlightMaskTexture = TEX(_RimlightMaskTexture, uv).rgb;
    half rimlightMaskValue = dot(rimlightMaskTexture, _RimlightMaskChannel);
    rimlightIntensity = pow(rimlightIntensity, _RimlightPower) * rimlightMaskValue;
    //rimlightIntensity = step(_RimlightFalloff, rimlightIntensity);
    
    half3 rimLight = rimlightIntensity * _RimlightColor * _RimlightInfluence;
    // Final Color
    half3 adsColor = ambient + specular + rimLight;
    half3 finalColor = adsColor  + emissive;

    // Dissolve
    half dx = IN.positionWS.x * 0.5 + 0.5;
    half dy = IN.positionWS.y * 0.5;
    dx += Random(uv * 200) * 0.1;
    half dissolveValue = Random(IN.positionWS.xy * _DissolveSize);
    half finalAlpha = 1 - step(_DissolveStep, dx);
 
    return half4(finalColor, finalAlpha);
}