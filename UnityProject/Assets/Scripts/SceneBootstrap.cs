using System.Collections.Generic;
using UnityEngine;

public static class SceneBootstrap
{
    private static readonly string[] AppNames =
    {
        "Camera", "Photos", "Maps", "Safari",
        "Messages", "Calendar", "Notes", "Music",
        "Weather", "Clock", "Calculator", "Voice Recorder",
        "Fitness", "Calls", "Settings", "Files"
    };

    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
    private static void EnsureObjects()
    {
        EnsureStereoRig();

        var surfaceControllerObject = GameObject.Find("ARSurfaceController") ?? new GameObject("ARSurfaceController");
        var surfaceController = surfaceControllerObject.GetComponent<ARSurfaceController>() ?? surfaceControllerObject.AddComponent<ARSurfaceController>();

        Material sharedPanelMaterial = BuildPanelMaterial();

        var surfaces = new List<SurfaceBinding>();
        var appBindings = new List<AppBinding>();
        var panelRenderers = new List<Renderer>();

        CreateSurface("braceletLeft", new Vector3(-0.22f, -0.06f, 0.72f), new Vector3(5f, 22f, 0f), new Vector2(0.24f, 0.17f), true, sharedPanelMaterial, surfaces, appBindings, panelRenderers);
        CreateSurface("braceletRight", new Vector3(0.22f, -0.06f, 0.72f), new Vector3(5f, -22f, 0f), new Vector2(0.24f, 0.17f), true, sharedPanelMaterial, surfaces, appBindings, panelRenderers);
        CreateSurface("widgetsPalm", new Vector3(0.0f, -0.11f, 0.62f), new Vector3(10f, 0f, 0f), new Vector2(0.30f, 0.30f), false, sharedPanelMaterial, surfaces, appBindings, panelRenderers);
        CreateSurface("notificationCenter", new Vector3(-0.26f, 0.02f, 0.68f), new Vector3(8f, 16f, 0f), new Vector2(0.26f, 0.30f), false, sharedPanelMaterial, surfaces, appBindings, panelRenderers);
        CreateSurface("controlCenter", new Vector3(0.26f, 0.02f, 0.68f), new Vector3(8f, -16f, 0f), new Vector2(0.26f, 0.30f), false, sharedPanelMaterial, surfaces, appBindings, panelRenderers);

        surfaceController.Configure(surfaces, appBindings);

        var bridgeObject = GameObject.Find("AuraOSBridge") ?? new GameObject("AuraOSBridge");
        var bridge = bridgeObject.GetComponent<AuraOSBridge>() ?? bridgeObject.AddComponent<AuraOSBridge>();
        bridge.Configure(surfaceController, panelRenderers);

        surfaceController.SetSelectedApp("Camera");
        surfaceController.SetSurface("braceletLeft");
    }

    private static void EnsureStereoRig()
    {
        var rig = GameObject.Find("StereoRig");
        if (rig == null)
        {
            rig = new GameObject("StereoRig");
            rig.transform.position = Vector3.zero;
            rig.transform.rotation = Quaternion.identity;
        }

        EnsureEyeCamera(rig.transform, "LeftEye", new Rect(0f, 0f, 0.5f, 1f), -0.016f, true);
        EnsureEyeCamera(rig.transform, "RightEye", new Rect(0.5f, 0f, 0.5f, 1f), 0.016f, false);

        var mainCamera = GameObject.Find("Main Camera");
        if (mainCamera != null)
        {
            var cam = mainCamera.GetComponent<Camera>();
            if (cam != null) cam.enabled = false;

            var listener = mainCamera.GetComponent<AudioListener>();
            if (listener != null) Object.Destroy(listener);
        }
    }

    private static void EnsureEyeCamera(Transform parent, string name, Rect viewport, float xOffset, bool withAudioListener)
    {
        var eye = GameObject.Find(name);
        if (eye == null)
        {
            eye = new GameObject(name);
        }

        eye.transform.SetParent(parent, false);
        eye.transform.localPosition = new Vector3(xOffset, 0f, 0f);
        eye.transform.localRotation = Quaternion.identity;

        var cam = eye.GetComponent<Camera>();
        if (cam == null)
        {
            cam = eye.AddComponent<Camera>();
        }

        // Rarely, Unity keeps an invalid/missing component reference on old objects.
        // If that happens, recreate the eye object so stereo bootstrap can continue.
        if (cam == null)
        {
            Debug.LogWarning($"[SceneBootstrap] {name} camera component invalid. Recreating eye object.");

            eye.SetActive(false);
            eye.name = $"{name}_Invalid";

            eye = new GameObject(name);
            eye.transform.SetParent(parent, false);
            eye.transform.localPosition = new Vector3(xOffset, 0f, 0f);
            eye.transform.localRotation = Quaternion.identity;

            cam = eye.AddComponent<Camera>();
            if (cam == null)
            {
                Debug.LogError($"[SceneBootstrap] Failed to create Camera on {name}. Stereo setup skipped for this eye.");
                return;
            }
        }

        cam.enabled = true;
        cam.rect = viewport;
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = Color.black;
        cam.fieldOfView = 56f;
        cam.nearClipPlane = 0.05f;
        cam.farClipPlane = 50f;
        cam.depth = 0;

        var listener = eye.GetComponent<AudioListener>();
        if (withAudioListener)
        {
            if (listener == null)
            {
                eye.AddComponent<AudioListener>();
            }
        }
        else if (listener != null)
        {
            Object.Destroy(listener);
        }
    }

    private static void CreateSurface(
        string key,
        Vector3 position,
        Vector3 euler,
        Vector2 panelSize,
        bool includeApps,
        Material sharedPanelMaterial,
        List<SurfaceBinding> surfaces,
        List<AppBinding> appBindings,
        List<Renderer> panelRenderers)
    {
        string rootName = key + "Root";
        var root = GameObject.Find(rootName) ?? new GameObject(rootName);
        root.transform.position = position;
        root.transform.rotation = Quaternion.Euler(euler);

        var panel = FindOrCreatePanel(root.transform, panelSize, sharedPanelMaterial);
        if (panel != null)
        {
            panelRenderers.Add(panel);
        }

        if (includeApps)
        {
            CreateBraceletAppVisuals(root.transform, appBindings);
        }

        surfaces.Add(new SurfaceBinding { key = key, root = root });
    }

    private static Renderer FindOrCreatePanel(Transform parent, Vector2 size, Material material)
    {
        var existing = parent.Find("SurfacePanel");
        GameObject panelObject;

        if (existing != null)
        {
            panelObject = existing.gameObject;
        }
        else
        {
            panelObject = GameObject.CreatePrimitive(PrimitiveType.Quad);
            panelObject.name = "SurfacePanel";
            panelObject.transform.SetParent(parent, false);
        }

        panelObject.transform.localPosition = Vector3.zero;
        panelObject.transform.localRotation = Quaternion.identity;
        panelObject.transform.localScale = new Vector3(size.x, size.y, 1f);

        var collider = panelObject.GetComponent<Collider>();
        if (collider != null)
        {
            Object.Destroy(collider);
        }

        var renderer = panelObject.GetComponent<Renderer>();
        if (renderer != null)
        {
            renderer.sharedMaterial = material;
        }

        return renderer;
    }

    private static void CreateBraceletAppVisuals(Transform root, List<AppBinding> appBindings)
    {
        var holder = root.Find("AppVisuals");
        if (holder == null)
        {
            var holderObject = new GameObject("AppVisuals");
            holderObject.transform.SetParent(root, false);
            holder = holderObject.transform;
        }

        holder.localPosition = new Vector3(0f, 0f, -0.01f);
        holder.localRotation = Quaternion.identity;

        for (int i = 0; i < AppNames.Length; i++)
        {
            string appName = AppNames[i];
            string visualName = appName.Replace(" ", "") + "Visual";

            var visual = holder.Find(visualName);
            if (visual == null)
            {
                var visualObject = new GameObject(visualName);
                visualObject.transform.SetParent(holder, false);
                visual = visualObject.transform;
            }

            visual.localPosition = new Vector3(0f, 0f, -0.005f);
            visual.localRotation = Quaternion.identity;

            var iconQuad = visual.Find("Icon");
            if (iconQuad == null)
            {
                var quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
                quad.name = "Icon";
                quad.transform.SetParent(visual, false);
                iconQuad = quad.transform;
            }

            iconQuad.localPosition = Vector3.zero;
            iconQuad.localRotation = Quaternion.identity;
            iconQuad.localScale = new Vector3(0.08f, 0.08f, 1f);

            var iconCollider = iconQuad.GetComponent<Collider>();
            if (iconCollider != null)
            {
                Object.Destroy(iconCollider);
            }

            var renderer = iconQuad.GetComponent<Renderer>();
            if (renderer != null)
            {
                renderer.sharedMaterial = BuildIconMaterial(i);
            }

            appBindings.Add(new AppBinding { appName = appName, visual = visual.gameObject });
        }
    }

    private static Material BuildPanelMaterial()
    {
        var shader = Shader.Find("Unlit/Texture") ?? Shader.Find("Standard");
        var material = new Material(shader)
        {
            color = Color.white
        };

        if (material.HasProperty("_BaseColor"))
        {
            material.SetColor("_BaseColor", Color.white);
        }

        return material;
    }

    private static Material BuildIconMaterial(int index)
    {
        Color[] palette =
        {
            new Color(0.10f, 0.55f, 0.95f),
            new Color(0.98f, 0.50f, 0.25f),
            new Color(0.28f, 0.78f, 0.42f),
            new Color(0.78f, 0.32f, 0.94f),
            new Color(0.96f, 0.30f, 0.45f),
            new Color(0.98f, 0.70f, 0.26f)
        };

        Color tint = palette[index % palette.Length];

        var shader = Shader.Find("Unlit/Color") ?? Shader.Find("Standard");
        var material = new Material(shader)
        {
            color = tint
        };

        if (material.HasProperty("_BaseColor"))
        {
            material.SetColor("_BaseColor", tint);
        }

        return material;
    }
}
