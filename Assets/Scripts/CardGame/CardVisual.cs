using UnityEngine;

public class CardVisual : MonoBehaviour
{
    void Update()
    {
        float sine = Mathf.Sin(Time.time) * 45f / 3.1415f;
        float cosine = Mathf.Cos(Time.time) * 45f / 3.1415f;

        transform.rotation = Quaternion.Euler(new Vector3(cosine, sine, 0));
    }
}
