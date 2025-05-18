using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;
public class DeckContainer : MonoBehaviour
{
    DeckData DeckData;
    Queue<CardData> CardData;
    public bool CanDraw => CardData.Count > 0;

    public void InitializeDeck(DeckData deckData)
    {
        System.Random rng = new System.Random();
        CardData = new Queue<CardData>(deckData.CardData.OrderBy(x => rng.Next()));
    }

    public CardData Draw()
    {
        return CardData.Peek();
    }
}
