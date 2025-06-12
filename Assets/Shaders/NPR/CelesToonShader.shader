Shader "Unlit/CelesToonShader"
{
    Properties
    {
        [Header(Base Color)]
        [Space(10)]
        [MainTexture] _BaseMap ("Base Map", 2D) = "white" {}
        [Toggle] _UseBaseColor ("Use Base Color ?", Float) = 0
        [HDR] [MainColor] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _ShadowIntensity ("Shadow Intensity", Range(0, 1)) = 0.8
        _ShadowMinValue ("Shadow Min Value", Range(0, 1)) = 0
        _ShadowMaxValue ("Shadow Max Value", Range(0, 1)) = 0.05
        _ShadowBand1 ("Shadow Band 1", Range(0, 1)) = 0.6
        _ShadowBand2 ("Shadow Band 2", Range(0, 1)) = 0.3
        
        // Shadow Map Properties
        [Toggle] _UseShadowMap ("Use Shadow Map ?", Float) = 1
        _ShadowMap ("Shadow Map", 2D) = "black" {}
        _ShadowMask ("Shadow Mask", 2D) = "black" {}
        _ShadowMaskChannel ("ShadowMaskChannel",  Vector) = (1, 0, 0, 0) 
        _ShadowMaskStepValue ("Shadow Mask Step Value", Range(0, 1)) = 0.5
        
        // Highlight
        [Header(Highlight)]
        [Space(10)]
        [Toggle] _UseHighlight ("Use High Color ?", Float) = 1
        [NoScaleOffset] _HighlightMap ("Highlight Map", 2D) = "white" {}
        _HighlightMaskChannel ("Highlight Mask Channel", Vector) = (0, 1, 0, 0)
        _HighlightIntensity ("Highlight Intensity", Range(0, 1)) = 1
        
        // Outline
        [Header(Outline)]
        [Space(10)]
        _OutlineWidth ("Outline Width", Range(0, 10)) = 1    
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1) 
        
        [Header(Ambient)]
        [Space(10)]
        _AmbientColor ("Ambient Color", Color) = (1, 1, 1, 1)
        _AmbientIntensity ("Ambient Intensity", Range(0, 1)) = 1
        _Alpha ("Alpha", Float) = 1

        [Header(Diffuse)]
        [Space(10)]
        _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
        _DiffuseIntensity ("Diffuse Intensity", Range(0, 1)) = 1

        [Header(Specular)]
        [Space(10)]
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecularPower ("Specular Power", Range(2, 256)) = 2
        _SpecularIntensity ("Specular Intensity", Range(0, 10)) = 1
        [Toggle] _UseLambert ("Use Lambert ?", Float) = 0
        [NoScaleOffset] _MetallicMap ("Metallic Map", 2D) = "black" {}
        [NoScaleOffset] _RoughnessMap ("Roughness Map", 2D) = "black" {}
        [NoScaleOffset] _SpecularMap ("Specular Map", 2D) = "black" {}
        _SpecularMaskChannel ("SpecularMaskChannel",  Vector) = (1, 0, 0, 0)
        
        [Header(Rimlight)]
        [Space(10)]
        [HDR] _RimlightColor ("Rimlight Color", Color) = (1, 1, 1, 1)
        _RimlightPower ("Rimlight Power", Range(0.1, 10)) = 2
        _RimlightFalloff ("Rimlight Falloff", Range(0, 1)) = 0.5
        _RimlightInfluence ("Rimlight Influence", Range(0, 1)) = 1.0
        [NoScaleOffset] _RimlightMaskTexture ("Rimlight Mask Texture", 2D) = "white" {}
        _RimlightMaskChannel ("Rimlight Mask Channel", Vector) = (0 ,0, 1, 0)
            
        [Header(Emission)]
        [Space(10)]
        [Toggle] _EnableEmission ("Enable Emission ?", Float) = 0
        [HDR] _EmissiveColor ("Emissive Color", Color) = (0, 0, 0)
        _EmissiveMulBaseColor ("Base Color Factor", Range(0, 1)) = 0
        [NoScaleOffset]_EmissiveMap ("Emissive Map", 2D) = "white" {}
        _EmissiveMapChannelMask ("Emissive Channel Mask", Vector) = (1, 1, 1, 0) 

        [Header(Occlusion)]
        [Space(10)]
        [Toggle] _EnableOcclusion("Enable Occlusion ?", Float) = 0
        _OcclusionStrength ("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        [NoScaleOffset] _OcclusionMap("Occlusion Map", 2D) = "white" {}
        _OcclusionMapChannelMask("Occlusion ChannelMask", Vector) = (1, 0, 0, 0)
        _OcclusionRemapStart("Occlusion Remap Start", Range(0, 1)) = 0
        _OcclusionRemapEnd("Occlusion Remap End", Range(0, 1)) = 1
        
        [Header(Dissolve)]
        [Space(10)]
        _DissolveStep ("Dissolve Frac Value", Range(0, 1)) = 1
        _DissolveSize ("Dissolve Size", Range(1, 500)) = 100
        _DissolveRandomMult ("Dissolve Random Mult", Float) = 43758.5453 
        _DissolveRandomComparer ("Dissolve Comparer", Vector) = (12.9898, 78.233, 0, 0) 
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
            "UniversalMaterialType" = "ComplexLit"
            "Queue"="Transparent"
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

        Pass
        {
            Name "OutlinePass"
            Tags
            {

            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite On
            Cull Front
            ZTest LEqual

            HLSLPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #define ToonShaderIsOutline

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "CelesToonShader_outline.hlsl"
           
            ENDHLSL
        }

        
    }
}
