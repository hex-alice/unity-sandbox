using System.Collections.Generic;
using UniRx;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using UnityEngine.XR;

public class CardContainer : MonoBehaviour
{
    [SerializeField] CardObject CardTemplate;
    [SerializeField] DeckContainer Deck;

    [SerializeField] CardObject SelectedCard;

    [SerializeField] List<CardObject> HandCardList = new();
    Queue<CardObject> UnusedCardList = new();

    void Update()
    {
        if (SelectedCard == null)
            return;

        // var selectedCardRect = SelectedCard.transform as RectTransform;

        for (int i = 0; i < HandCardList.Count; i++)
        {
            var currentCard = HandCardList[i];
            if (SelectedCard == currentCard)
                continue;

            // If SelectedCard is to the left of currentCard (or whatever logic you want)
                if (SelectedCard.transform.position.x > currentCard.transform.position.x)
                {
                    int selectedIndex = HandCardList.IndexOf(SelectedCard);

                    if (selectedIndex > i)
                        continue;

                    HandCardList[i] = SelectedCard;
                    HandCardList[selectedIndex] = currentCard;

                    break;
                }
                else if (SelectedCard.transform.position.x < currentCard.transform.position.x)
                {
                    // Also swap in your HandCardList so data matches UI
                    int selectedIndex = HandCardList.IndexOf(SelectedCard);

                    if (selectedIndex < i)
                        continue;

                    HandCardList[i] = SelectedCard;
                    HandCardList[selectedIndex] = currentCard;
                    break;
                }
        }
        
        UpdateCard(false);
    }

    void UpdateCard(bool skipTween)
    {
        var cardCount = HandCardList.Count;

        if (cardCount == 0)
            return;

        var cardSpacing = 1f / cardCount;
        var firstCardPos = 0.5f - (cardCount - 1) * cardSpacing / 2;

        var rect = transform as RectTransform;
        var width = rect.sizeDelta.x;
     
        for (int i = 0; i < cardCount; i++)
        {
            if (SelectedCard != null && SelectedCard == HandCardList[i])
                continue;

            var cardRect =  HandCardList[i].transform as RectTransform;

            var targetValue = firstCardPos + i * cardSpacing;
            var targetPos = targetValue * (width - cardRect.sizeDelta.x);

            if (skipTween)
            {
                cardRect.anchoredPosition = new Vector2(targetPos, 0);
            }
            else
            {
                cardRect.DOAnchorPos(new Vector2(targetPos, 0), 1f);
            }
        }
    }

    public void AddHand()
    {
        CardObject addedCard;

        if (UnusedCardList.Count > 0)
        {
            addedCard = UnusedCardList.Peek();

            addedCard.transform.position = Deck.transform.position;
            addedCard.gameObject.SetActive(true);
        }
        else
        {
            addedCard = Instantiate(CardTemplate, transform);
            addedCard.transform.position = Deck.transform.position;

            RegisterCardEvent(addedCard);
        }

        addedCard.name = HandCardList.Count.ToString();

        HandCardList.Add(addedCard);
        UpdateCard(false);
    }

    void RegisterCardEvent(CardObject cardObject)
    {
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
            .Subscribe(OnBeginDrag)
            .AddTo(this);

        cardObject.OnEndDragAsObservable
            .Subscribe(OnEndDrag)
            .AddTo(this);

        cardObject.OnDragAsObservable
            .Subscribe(OnDrag)
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
       
    }

    void OnPointerExit(CardObject cardObject)
    {
       
    }

    void OnPointerUp(CardObject cardObject)
    {
       
    }

    void OnBeginDrag(CardObject cardObject)
    {
        SelectedCard = cardObject;
    }

    void OnEndDrag(CardObject cardObject)
    {
        SelectedCard = null;
         UpdateCard(false);
    }

    void OnDrag(CardObject cardObject)
    {

    }

    public void RemoveHand()
    {

    }
}
