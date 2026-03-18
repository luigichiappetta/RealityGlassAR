using System;
using System.Collections.Generic;
using UnityEngine;

public class AuraOSBridge : MonoBehaviour
{
    [SerializeField] private ARSurfaceController surfaceController;
    [SerializeField] private List<Renderer> uiRenderers = new List<Renderer>();

    private readonly List<Renderer> runtimeRenderers = new List<Renderer>();
    private Texture2D uiTexture;

    private void Awake()
    {
        if (surfaceController == null)
        {
            surfaceController = FindFirstObjectByType<ARSurfaceController>();
        }

        CacheFallbackRenderers();
    }

    public void Configure(ARSurfaceController controller, List<Renderer> renderers)
    {
        surfaceController = controller;
        uiRenderers = renderers ?? new List<Renderer>();
        CacheFallbackRenderers();
    }

    public void SetSurface(string surface)
    {
        if (surfaceController != null)
        {
            surfaceController.SetSurface(surface);
        }
    }

    public void SetSelectedApp(string appName)
    {
        if (surfaceController != null)
        {
            surfaceController.SetSelectedApp(appName);
        }
    }

    public void UpdateTexture(string base64)
    {
        if (string.IsNullOrEmpty(base64)) return;

        try
        {
            byte[] bytes = Convert.FromBase64String(base64);
            if (uiTexture == null)
            {
                uiTexture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
                uiTexture.wrapMode = TextureWrapMode.Clamp;
                uiTexture.filterMode = FilterMode.Bilinear;
            }

            uiTexture.LoadImage(bytes, false);

            foreach (var renderer in GetRenderers())
            {
                if (renderer == null) continue;

                var material = renderer.sharedMaterial;
                if (material == null) continue;

                material.mainTexture = uiTexture;
                if (material.HasProperty("_BaseMap"))
                {
                    material.SetTexture("_BaseMap", uiTexture);
                }
            }
        }
        catch (Exception ex)
        {
            Debug.LogWarning($"Texture decode failed: {ex.Message}");
        }
    }

    private IEnumerable<Renderer> GetRenderers()
    {
        if (uiRenderers != null && uiRenderers.Count > 0)
        {
            return uiRenderers;
        }

        return runtimeRenderers;
    }

    private void CacheFallbackRenderers()
    {
        runtimeRenderers.Clear();

        if (uiRenderers != null && uiRenderers.Count > 0)
        {
            runtimeRenderers.AddRange(uiRenderers);
            return;
        }

        var allRenderers = FindObjectsByType<Renderer>(FindObjectsSortMode.None);
        foreach (var renderer in allRenderers)
        {
            if (renderer == null || renderer.gameObject == null) continue;
            if (renderer.gameObject.name.IndexOf("Panel", StringComparison.OrdinalIgnoreCase) >= 0 ||
                renderer.gameObject.name.Equals("UIQuad", StringComparison.OrdinalIgnoreCase))
            {
                runtimeRenderers.Add(renderer);
            }
        }
    }
}
