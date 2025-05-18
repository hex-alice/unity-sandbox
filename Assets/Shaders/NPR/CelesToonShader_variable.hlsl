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
    float4 positionWS : TEXCOORD1;
    float3 normalWS   : TEXCOORD2;

    float4 positionCS : SV_POSITION;

    //UNITY_VERTEX_INPUT_INSTANCE_ID
    //UNITY_VERTEX_OUTPUT_STEREO
};

struct ToonSurfaceData
{
    half3 albedo;
    half  alpha;
    half3 emission;
    half  occlusion;
};

struct ToonLightingData
{
    half3  normalWS;
    float3 positionWS;
    half3  viewDirectionWS;
    float4 shadowCoord;
};

sampler2D _BaseMap;
float4 _BaseMap_ST;

float4 _BaseColor;
float4 _ShadowIntensity;