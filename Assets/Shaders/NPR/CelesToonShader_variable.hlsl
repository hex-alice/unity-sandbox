struct Attributes
{
    float4 positionOS : POSITION;
    half3 normalOS    : NORMAL;
    half4 tangentOS   : TANGENT;

    float2 uv : TEXCOORD0;

    //UNITY_VERTEX_INPUT_INSTANCE_ID // For GPU Instancing
};

struct Varyings
{
    float2 uv         : TEXCOORD0;
    float3 positionWS : TEXCOORD1;
    float3 normalWS   : TEXCOORD2;
    float3 positionVS : TEXCOORD3;

    float4 positionCS : SV_POSITION;

    //UNITY_VERTEX_INPUT_INSTANCE_ID
    //UNITY_VERTEX_OUTPUT_STEREO
};

struct ToonSurfaceData
{
    half3 albedo;
    half3 specular;
    half  metallic;
    half  smoothness;
    half3 emission;
    half  occlusion;
    half  alpha;
};

struct ToonLightingData
{
    half3  normalWS;
    float3 positionWS;
    half3  viewDirectionWS;
    float4 shadowCoord;
};

// Base
sampler2D _BaseMap;
float4 _BaseMap_ST;

float4 _BaseColor;
float _UseBaseColor;
float _ShadowIntensity;
float _ShadowMinValue;
float _ShadowMaxValue;
float _ShadowBand1;
float _ShadowBand2;

// Outline
float _OutlineWidth;
float4 _OutlineColor;

// Shadow Map
float _UseShadowMap;
sampler2D _ShadowMap;
float4 _ShadowMap_ST;
sampler2D _ShadowMask;
float4 _ShadowMask_ST;
float4 _ShadowMaskChannel;
float _ShadowMaskStepValue;

// Highlight
float _UseHighlight;
sampler2D _HighlightMap;
float4 _HighlightMap_ST;
float4 _HighlightMaskChannel;
float _HighlightIntensity;

float4 _AmbientColor;
float _AmbientIntensity;
half _Alpha;

float4 _DiffuseColor;
float _DiffuseIntensity;

float4 _SpecularColor;
float _SpecularPower;
float _SpecularIntensity;
float _UseLambert;
float4 _SpecularMaskChannel;

sampler2D _MetallicMap;
float4 _MetallicMap_ST;
sampler2D _RoughnessMap;
float4 _RoughnessMap_ST;
sampler2D _SpecularMap;
float4 _SpecularMap_ST;

// Rimlight
float4 _RimlightColor;
float _RimlightPower;
float _RimlightFalloff;
float _RimlightInfluence;
sampler2D _RimlightMaskTexture;
float4 _RimlightMaskTexture_ST;
float4 _RimlightMaskChannel;

// Emissive
float _EnableEmission;
float4 _EmissiveColor;
float _EmissiveMulBaseColor;
sampler2D _EmissiveMap;
float4 _EmissiveMapChannelMask;

// Dissolve
float _DissolveStep;
float _DissolveSize;
float _DissolveRandomMult; 
float4 _DissolveRandomComparer;

// Occlusion
float _EnableOcclusion;
float _OcclusionStrength;
sampler2D _OcclusionMap;
float4 _OcclusionMapChannelMask;
float _OcclusionRemapStart;
float _OcclusionRemapEnd;


