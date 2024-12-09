using UnityEngine;

public class LUTToggle : MonoBehaviour
{
    [SerializeField] GameObject LutOverlay;

    void Update()
    {
        if (Input.GetKeyDown("l"))
        {
            LutOverlay.SetActive(!LutOverlay.activeInHierarchy);
        }
    }
}
