using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class SurfaceBinding
{
    public string key;
    public GameObject root;
}

[Serializable]
public class AppBinding
{
    public string appName;
    public GameObject visual;
}

public class ARSurfaceController : MonoBehaviour
{
    [SerializeField] private List<SurfaceBinding> surfaces = new List<SurfaceBinding>();
    [SerializeField] private List<AppBinding> braceletApps = new List<AppBinding>();

    private string currentSurface = "braceletLeft";
    private string currentApp = "Camera";

    private void Awake()
    {
        ApplySurfaceState();
        ApplyAppState();
    }

    public void Configure(List<SurfaceBinding> configuredSurfaces, List<AppBinding> configuredApps)
    {
        surfaces = configuredSurfaces ?? new List<SurfaceBinding>();
        braceletApps = configuredApps ?? new List<AppBinding>();
        ApplySurfaceState();
        ApplyAppState();
    }

    public void SetSurface(string surface)
    {
        if (string.IsNullOrWhiteSpace(surface)) return;
        currentSurface = surface;
        ApplySurfaceState();
    }

    public void SetSelectedApp(string appName)
    {
        if (!string.IsNullOrWhiteSpace(appName))
        {
            currentApp = appName;
        }

        ApplyAppState();
    }

    private void ApplySurfaceState()
    {
        if (surfaces == null || surfaces.Count == 0) return;

        foreach (var item in surfaces)
        {
            if (item == null || item.root == null) continue;
            bool isActive = string.Equals(item.key, currentSurface, StringComparison.OrdinalIgnoreCase);
            item.root.SetActive(isActive);
        }
    }

    private void ApplyAppState()
    {
        if (braceletApps == null || braceletApps.Count == 0) return;

        bool hasAnyEnabled = false;
        foreach (var item in braceletApps)
        {
            if (item == null || item.visual == null) continue;

            bool isActive = string.Equals(item.appName, currentApp, StringComparison.OrdinalIgnoreCase);
            item.visual.SetActive(isActive);
            if (isActive) hasAnyEnabled = true;
        }

        if (!hasAnyEnabled)
        {
            foreach (var item in braceletApps)
            {
                if (item == null || item.visual == null || string.IsNullOrWhiteSpace(item.appName)) continue;
                currentApp = item.appName;
                item.visual.SetActive(true);
                break;
            }
        }
    }
}
