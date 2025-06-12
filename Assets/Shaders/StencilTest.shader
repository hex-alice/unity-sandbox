Shader "Unlit/StencilTest"
{
    Properties
        {
            _OutlineColor("Outline Color", Color) = (0,0,0,1)
            _OutlineWidth("Outline width", Range(1, 50)) = 2
    
            [HideInInspector] _Mode("__mode", Float) = 0.0
            [HideInInspector] _SrcBlend("__src", Float) = 1.0
            [HideInInspector] _DstBlend("__dst", Float) = 0.0
            [HideInInspector] _ZWrite("__zw", Float) = 1.0
        }
    
        SubShader
        {
            Tags { "RenderType" = "Outline" "Queue" = "Geometry-1"  }
    
    
            Pass
            {
                Tags { "LightMode" = "Always" }
                ColorMask 0
                Cull Off
                ZWrite Off
                Stencil
                {
                    Ref 1
                    Comp always
                    Pass replace
                }
    
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                struct appdata {
                    float4 vertex : POSITION;
                };
                struct v2f {
                    float4 pos : SV_POSITION;
                };
                v2f vert(appdata v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    return o;
                }
                half4 frag(v2f i) : SV_Target {
                    return half4(1,0,0,1);
                }
                ENDCG
            }
    
            Pass
            {
                Tags { "LightMode" = "Always" }
                Cull Off
                ZWrite On
                Stencil
                {
                    Ref 1
                    Comp notequal
                    Pass keep
                    Fail keep
                }
    
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
    
                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };
    
                struct v2f
                {
                    float4 pos : SV_POSITION;
                    fixed4 color : COLOR;
                };
    
                uniform float _OutlineWidth;
                uniform float4 _OutlineColor;
                uniform float4x4 _ObjectToWorldFixed;
    
                v2f vert(appdata v)
                {
                    v2f o;
                    float4 objectCenterWorld = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0, 1.0));
                    float4 vertWorld = mul(unity_ObjectToWorld, v.vertex);
    
                    float3 offsetDir = vertWorld.xyz - objectCenterWorld.xyz;
                    offsetDir = normalize(offsetDir) * (_OutlineWidth / 1000);
    
                    o.pos = UnityWorldToClipPos(vertWorld + offsetDir);
    
                    o.color = _OutlineColor;
                    return o;
                }
                fixed4 frag(v2f i) : SV_Target
                {
                    return i.color;
                }
                ENDCG
            }
        }
        Fallback Off
}
