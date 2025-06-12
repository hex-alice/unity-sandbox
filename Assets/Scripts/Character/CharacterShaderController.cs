using System;
using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;

namespace Celes
{
    enum RGBA
    {
        R,
        G,
        B,
        A
    }
    
    public class CharacterShaderController : MonoBehaviour
    {
        [SerializeField] List<SkinnedMeshRenderer> _skinnedMeshRendererList = new();
        
        [Range(0, 1)]
        [SerializeField] float _ambientIntensity = 1;
        
        [Range(0, 1)]
        [SerializeField] float _diffuseIntensity = 1;
        
        [Range(0, 20)]
        [SerializeField] float _specularIntensity = 1;
        
        [Range(2, 100)]
        [SerializeField] int _shininess = 2;
        
        [Range(0, 1)]
        [SerializeField] float _shadowMaxValue = 1;
        
        [Range(0, 1)]
        [SerializeField] float _shadowMinValue = 1;
        
        [Range(0, 1)]
        [SerializeField] float _shadowMaskStepValue = 0.6f;
        
        [Range(0, 1)]
        [SerializeField] float _shadowBand1= 1;
        
        [Range(0, 1)]
        [SerializeField] float _shadowBand2 = 1;
        
        [Range(0, 1)]
        [SerializeField] float _outlineWidth = 0.01f;
        
        [SerializeField] RGBA _specularChannel = RGBA.G;
        [SerializeField] bool _useBaseColor = false;
        
        [SerializeField] Color _rimlightColor;
        
        [Range(0.1f, 10)]
        [SerializeField] float _rimlightPower;
        
        [Range(0, 1)]
        [SerializeField] float _rimlightFalloff;
        
        [Range(0, 1)]
        [SerializeField] float _rimlightInfluence;
        
        [Range(0, 1)]
        [SerializeField] float _dissolveFracValue;
        
        [Range(1, 500)]
        [SerializeField] float _dissolveSize;
        
        [ContextMenu("Fetch SkinnedMeshRendererData")]
        public void FetchSkinnedMeshRendererData()
        {
            FetchData(transform);
        }
        
        private void OnValidate()
        {
            foreach (var skinnedMeshRenderer in _skinnedMeshRendererList)
            {
                foreach (var material in skinnedMeshRenderer.materials)
                {
                    material.SetFloat("_AmbientIntensity", _ambientIntensity);
                    material.SetFloat("_DiffuseIntensity", _diffuseIntensity);
                    material.SetFloat("_SpecularIntensity", _specularIntensity);
                    material.SetFloat("_SpecularPower", _shininess);
                    material.SetFloat("_ShadowMaxValue", _shadowMaxValue);
                    material.SetFloat("_ShadowMinValue", _shadowMinValue);
                    material.SetFloat("_ShadowMaskStepValue", _shadowMaskStepValue);
                    material.SetFloat("_ShadowBand1", _shadowBand1);
                    material.SetFloat("_ShadowBand2", _shadowBand2);
                    material.SetFloat("_OutlineWidth", _outlineWidth);
                    
                    material.SetColor("_RimlightColor", _rimlightColor);
                    material.SetFloat("_RimlightPower", _rimlightPower);
                    material.SetFloat("_RimlightFalloff", _rimlightFalloff);
                    material.SetFloat("_RimlightInfluence", _rimlightInfluence);
                    material.SetFloat("_DissolveStep", _dissolveFracValue);
                    material.SetFloat("_DissolveSize", _dissolveSize);
                    
                    var specularMask = new Vector4(0, 0, 0, 0);
                    if (_specularChannel == RGBA.R)
                    {
                        specularMask.x = 1;
                    }
                    else if (_specularChannel == RGBA.G)
                    {
                        specularMask.y = 1;
                    }
                    else if (_specularChannel == RGBA.B)
                    {
                        specularMask.z = 1;
                    }
                    else
                    {
                        specularMask.w = 1;
                    }
                    material.SetVector("_SpecularMaskChannel", specularMask);
                    
                    material.SetFloat("_UseBaseColor", _useBaseColor ? 1 : 0);
                }
            }
        }
        
        private void FetchData(Transform baseTransform)
        {
            var smr = baseTransform.GetComponent<SkinnedMeshRenderer>();
            if (smr != null)
            {
                _skinnedMeshRendererList.Add(smr);
            }
            
            foreach (Transform child in baseTransform)
            {
                FetchData(child);
            }
        }

      
        
        
    }
}

