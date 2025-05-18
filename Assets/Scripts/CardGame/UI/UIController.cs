using UniRx;
using UnityEngine;

public class UIController : MonoBehaviour
{
    [SerializeField] UIView View;
    [SerializeField] CardContainer HandCard;

    void Awake()
    {
        View.OnClickAddHandButton
            .Subscribe(_ => HandCard.AddHand())
            .AddTo(this);
    }
}
