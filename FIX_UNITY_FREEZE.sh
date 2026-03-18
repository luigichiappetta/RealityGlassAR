#!/bin/zsh
set -euo pipefail

PROJECT_DIR="${1:-$HOME/Documents/AuraOS/AuraOS-Rebuild/UnityProject}"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Project directory not found: $PROJECT_DIR"
  exit 1
fi

cd "$PROJECT_DIR"

echo "Cleaning Unity caches..."
chmod -R u+w Library Temp Obj Logs UserSettings 2>/dev/null || true
rm -rf Library Temp Obj Logs UserSettings
rm -f Packages/packages-lock.json

# Remove accidental embedded package leftovers
rm -rf Packages/com.unity.render-pipelines.core
rm -rf Packages/com.unity.render-pipelines.universal
rm -rf Packages/com.unity.render-pipelines.universal-config
rm -rf Packages/com.unity.shadergraph

# Remove orphan .meta inside Packages
find Packages -name "*.meta" -type f -delete || true

echo "Writing safe manifest (built-in pipeline)..."
cat > Packages/manifest.json <<'JSON'
{
  "dependencies": {
    "com.unity.textmeshpro": "3.0.6",
    "com.unity.ugui": "1.0.0",
    "com.unity.modules.ai": "1.0.0",
    "com.unity.modules.animation": "1.0.0",
    "com.unity.modules.audio": "1.0.0",
    "com.unity.modules.director": "1.0.0",
    "com.unity.modules.imageconversion": "1.0.0",
    "com.unity.modules.jsonserialize": "1.0.0",
    "com.unity.modules.particlesystem": "1.0.0",
    "com.unity.modules.physics": "1.0.0",
    "com.unity.modules.physics2d": "1.0.0",
    "com.unity.modules.screencapture": "1.0.0",
    "com.unity.modules.ui": "1.0.0",
    "com.unity.modules.uielements": "1.0.0",
    "com.unity.modules.umbra": "1.0.0",
    "com.unity.modules.unitywebrequest": "1.0.0"
  }
}
JSON

echo "Done. Re-open this project from Unity Hub using 2022.3.62f3."
