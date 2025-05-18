using System.Collections.Generic;
using UniRx;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class CardContainer : MonoBehaviour
{
    [SerializeField] CardObject CardTemplate;
    [SerializeField] GameObject ContainerTemplate;
    [SerializeField] Transform ContainerTransform;
    [SerializeField] DeckContainer Deck;

    List<CardObject> HandCardList = new();
    Queue<CardObject> UnusedCardList = new();

    List<GameObject> HandCardObject = new();
    Queue<GameObject> UnusedCardObject = new();


    [ContextMenu("Add Hand")]
    public void AddHand()
    {
        CardObject addedCard;
        GameObject cardContainer;

        if (UnusedCardObject.Count > 0)
        {
            cardContainer = UnusedCardObject.Peek();

        }
        else
        {
            cardContainer = Instantiate(ContainerTemplate, transform);
        }

        if (UnusedCardList.Count > 0)
        {
            addedCard = UnusedCardList.Peek();

            addedCard.transform.position = Deck.transform.position;
            addedCard.gameObject.SetActive(true);
        }
        else
        {
            // var deckTransform = Deck.transform as RectTransform;
            // var containerTransform = cardContainer.transform as RectTransform;

            // addedCard = Instantiate(CardTemplate, ContainerTransform);

            // var addedCardTransform = addedCard.gameObject.transform as RectTransform;
            // addedCardTransform.anchoredPosition = deckTransform.anchoredPosition;
            // addedCard.transform.SetParent(cardContainer.transform, worldPositionStays: true);

            // Debug.Log(addedCardTransform.anchoredPosition);
            // Debug.Log(containerTransform.anchoredPosition);

            // addedCardTransform.DOAnchorPos(containerTransform.anchoredPosition, 1f);

            // RegisterCardEvent(addedCard);

            // 1. Instantiate card under a neutral layer
            addedCard = Instantiate(CardTemplate, ContainerTransform);
            RectTransform cardRect = addedCard.GetComponent<RectTransform>();

            // 2. Set its world position to match Deck
            cardRect.position = Deck.GetComponent<RectTransform>().position;

            // 3. Animate to CardContainer position (world space)
            Vector3 targetPos = cardContainer.GetComponent<RectTransform>().position;

            LayoutRebuilder.ForceRebuildLayoutImmediate(this.transform as RectTransform);

            cardRect.DOMove(targetPos, 0.5f).OnComplete(() =>
            {
                // // 4. Reparent to CardContainer after animation
                // cardRect.SetParent(cardContainer.transform, worldPositionStays: false);
                // cardRect.anchoredPosition = Vector2.zero; // Snap to layout slot if needed
            });

            RegisterCardEvent(addedCard); 
        }
    }

    void RegisterCardEvent(CardObject cardObject)
    {
        Debug.Log("Register");

        cardObject.OnPointerEnterAsObservable
            .Subscribe(OnPointerEnter)
            .AddTo(this);
        
        cardObject.OnPointerExitAsObservable
            .Subscribe(OnPointerExit)
            .AddTo(this);

        cardObject.OnPointerClickAsObservable
            .Subscribe()
            .AddTo(this);

        cardObject.OnPointerUpAsObservable
            .Subscribe(OnPointerUp)
            .AddTo(this);

        cardObject.OnPointerDownAsObservable
            .Subscribe()
            .AddTo(this);

        cardObject.OnBeginDragAsObservable
            .Subscribe()
            .AddTo(this);

        cardObject.OnEndDragAsObservable
            .Subscribe()
            .AddTo(this);

        cardObject.OnPointerEnterAsObservable
            .Subscribe(OnPointerEnter)
            .AddTo(this);
        
        cardObject.OnPointerExitAsObservable
            .Subscribe(OnPointerExit)
            .AddTo(this);
    }

    void OnPointerEnter(CardObject cardObject)
    {
        Debug.Log("OnPointerEnter");
    }

    void OnPointerExit(CardObject cardObject)
    {
        Debug.Log("OnPointerExit");
    }

    void OnPointerUp(CardObject cardObject)
    {
        cardObject.transform.localPosition = Vector3.zero;
    }

    public void RemoveHand()
    {

    }
}
