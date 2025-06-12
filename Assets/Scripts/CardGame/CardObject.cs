using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.UIElements;
using UniRx;
using System;

public class CardObject : MonoBehaviour, 
        IDragHandler, IBeginDragHandler, IEndDragHandler, 
        IPointerEnterHandler, IPointerExitHandler, IPointerUpHandler, 
        IPointerDownHandler
{
    [SerializeField] float moveSpeedLimit;
    [SerializeField] Vector3 offset;
    private bool _isDragging;
    private CardData _cardData;

    Subject<CardObject> _onPointerEnter = new Subject<CardObject>();
    Subject<CardObject> _onPointerExit = new Subject<CardObject>();
    Subject<CardObject> _onBeginDrag = new Subject<CardObject>();
    Subject<CardObject> _onDrag = new Subject<CardObject>();
    Subject<CardObject> _onEndDrag = new Subject<CardObject>();
    Subject<CardObject> _onPointerClick = new Subject<CardObject>();
    Subject<CardObject> _onPointerUp = new Subject<CardObject>();
    Subject<CardObject> _OnPointerDown = new Subject<CardObject>();

    [Header("Events")]
    public IObservable<CardObject> OnPointerEnterAsObservable => _onPointerEnter;
    public IObservable<CardObject> OnPointerExitAsObservable => _onPointerExit;
    public IObservable<CardObject> OnPointerClickAsObservable => _onPointerClick;
    public IObservable<CardObject> OnPointerUpAsObservable => _onPointerUp;
    public IObservable<CardObject> OnPointerDownAsObservable => _OnPointerDown;
    public IObservable<CardObject> OnBeginDragAsObservable => _onBeginDrag;
    public IObservable<CardObject> OnDragAsObservable => _onDrag;
    public IObservable<CardObject> OnEndDragAsObservable => _onEndDrag;

    void Start() 
    {
        
    }

    void Update()
    {

    }

    public void SetCardData(CardData cardData)
    {
        _cardData = cardData;
    }

    void ClampPosition()
    {
        Vector2 screenBounds = Camera.main.ScreenToWorldPoint(new Vector3(Screen.width, Screen.height, Camera.main.transform.position.z));
        Vector3 clampedPosition = transform.position;
        clampedPosition.x = Mathf.Clamp(clampedPosition.x, -screenBounds.x, screenBounds.x);
        clampedPosition.y = Mathf.Clamp(clampedPosition.y, -screenBounds.y, screenBounds.y);
        transform.position = new Vector3(clampedPosition.x, clampedPosition.y, 0);
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        _onBeginDrag.OnNext(this);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        _onEndDrag.OnNext(this);
    }

    public void OnDrag(PointerEventData eventData)
    {
        transform.position = new Vector3(eventData.position.x, eventData.position.y, 0);
        _onDrag.OnNext(this);
    }

    public void OnPointerClick(PointerEventData pointerEventData)
    {
        
    }

    public void OnPointerEnter(PointerEventData pointerEventData)
    {

        Debug.Log("Card OnPointerEnter");
        _onPointerEnter.OnNext(this);
    }

    public void OnPointerExit(PointerEventData pointerEventData)
    {
        Debug.Log("Card OnPointerExit");
        _onPointerExit.OnNext(this);
    }

    public void OnPointerUp(PointerEventData pointerEventData)
    {
        Debug.Log("Card OnPointerUp");
        _onPointerUp.OnNext(this);
    }

    public void OnPointerDown(PointerEventData pointerEventData)
    {
        
    }
}
