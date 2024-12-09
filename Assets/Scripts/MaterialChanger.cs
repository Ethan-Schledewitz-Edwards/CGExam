
using System.Collections.Generic;
using UnityEngine;

public class MaterialChanger : MonoBehaviour
{
    [SerializeField] private Material normal;
    [SerializeField] private Material PBalloon;
    [SerializeField] private Material Hologram;

    [SerializeField] private MeshRenderer meshRenderer;

    private void Update()
    {
        if (Input.GetKeyDown("1"))
        {
            List<Material> mats = new List<Material>
            {
                normal,
                normal
            };

            Debug.Log("Set Normal");
            meshRenderer.sharedMaterials = mats.ToArray();
        }
        else if (Input.GetKeyDown("2"))
        {
            List<Material> mats = new List<Material>
            {
                PBalloon,
                normal
            };

            Debug.Log("Set Balloon");
            meshRenderer.sharedMaterials = mats.ToArray();
        }
        else if (Input.GetKeyDown("3"))
        {
            List<Material> mats = new List<Material>
            {
                Hologram,
                Hologram
            }; 

            Debug.Log("Set Hologram");
            meshRenderer.sharedMaterials = mats.ToArray();
        }
    }
}
