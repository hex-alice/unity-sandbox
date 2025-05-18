Shader "Unlit/CelesToonShader"
{
    Properties
    {
        [Header(Base Color)]
        [MainTexture] _BaseMap ("Base Color", 2D) = "white" {}
        [HDR] [MainColor] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)

        _ShadowColor ("Shadow Color", Color) = (1, 1, 1, 1)
        _ShadowIntensity ("Shadow Intensity", float) = 0.8
        _LightShadowIntensity (" Light Shadow Intensity", float) = 0.8
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Transparent"="Transparent" 

            "RenderPipeline" = "UniversalPipeline"
        }

        LOD 100

        Pass
        {
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForwardOnly"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite On
            Cull Off
            ZTest LEqual

           

            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "CelesToonShader_forward.hlsl"
           
            ENDHLSL
        }
    }
}
