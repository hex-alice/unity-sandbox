Shader "Unlit/EyeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HighlightTex ("Hi1", 2D) = "white" {}
        _HighlightTex2 ("Hi2", 2D) = "white" {}
        _HighlightTex3 ("Hi3", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _HighlightTex;
            float4 _HighlightTex_ST;

            sampler2D _HighlightTex2;
            float4 _HighlightTex2_ST;

            sampler2D _HighlightTex3;
            float4 _HighlightTex3_ST;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 base = tex2D(_MainTex, i.uv);
                fixed4 hi1 = tex2D(_HighlightTex, i.uv);
                fixed4 hi2 = tex2D(_HighlightTex2, i.uv);
                fixed4 hi3 = tex2D(_HighlightTex3, i.uv);

                return base + hi1 + hi2 + hi3;
            }
            ENDCG
        }
    }
}
