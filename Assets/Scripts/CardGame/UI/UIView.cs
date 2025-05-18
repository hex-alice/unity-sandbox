using System;
using UniRx;
using UnityEngine;
using UnityEngine.UI;

public class UIView : MonoBehaviour
{
    [SerializeField] Button AddHandButton;

    public IObservable<Unit> OnClickAddHandButton => AddHandButton.OnClickAsObservable();
}
