# Setup Complete: Unity Export + Safe Backup + GitHub + Xcode

## 1) Project layout
- iOS project: `/tmp/AuraOS-Rebuild/iOS/AuraOS-Rebuild.xcodeproj`
- iOS sources: `/tmp/AuraOS-Rebuild/iOS/AuraOS-Rebuild`
- Unity project: `/tmp/AuraOS-Rebuild/UnityProject`

Move this folder out of `/tmp` before real work:
```bash
mv /tmp/AuraOS-Rebuild ~/Documents/AuraOS-Rebuild
```

## 2) Open Unity project correctly
1. Unity Hub -> Add -> `~/Documents/AuraOS-Rebuild/UnityProject`
2. Open scene: `Assets/Scenes/Main.unity`
3. Confirm scripts compile: `AuraOSBridge`, `ARSurfaceController`, `SceneBootstrap`

## 3) Unity export to iOS (safe)
1. File -> Save Project
2. File -> Build Settings -> iOS
3. Check `Export Project`
4. Build path must be OUTSIDE Unity project, example:
   - `~/Documents/AuraOS-Rebuild/Builds/Unity-iOS`
5. Do not build inside `Assets/` or inside Xcode project folders.

## 4) Embed Unity in Xcode without duplicates
1. Open `AuraOS-Rebuild.xcodeproj`
2. Drag `UnityFramework.framework` from Unity build output into Xcode.
3. In target `AuraOS-Rebuild` -> `Frameworks, Libraries, and Embedded Content`:
   - `UnityFramework.framework` = `Embed & Sign`
4. Check Build Phases:
   - `UnityFramework.framework` must appear once.
   - Remove duplicates from `Copy Bundle Resources`.
5. Build and run.

If you get `Multiple commands produce`, it is almost always duplicate framework/resource entries.

## 5) GitHub safe workflow (never lose project again)

### A) Create repo and first push
```bash
cd ~/Documents/AuraOS-Rebuild
git init
git checkout -b main
cat > .gitignore <<'GITIGNORE'
# Xcode
DerivedData/
*.xcuserdata
*.xcuserstate

# Unity
UnityProject/[Ll]ibrary/
UnityProject/[Tt]emp/
UnityProject/[Oo]bj/
UnityProject/[Bb]uild/
UnityProject/[Bb]uilds/
UnityProject/[Ll]ogs/
UnityProject/[Uu]ser[Ss]ettings/

# macOS
.DS_Store
GITIGNORE

git add .
git commit -m "Initial rebuild"
```

### B) Connect real GitHub repo
1. Create empty repo on GitHub (web), example `AuraOS-Rebuild`.
2. Then:
```bash
git remote add origin git@github.com:<TUO_USERNAME>/AuraOS-Rebuild.git
git push -u origin main
```

## 6) Connect your real GitHub account in Xcode
1. Xcode -> Settings -> Accounts
2. `+` -> GitHub
3. Sign in with your real account (browser flow)
4. In Source Control Navigator, verify remote is your repo URL.

## 7) Commit from Xcode to your real account
1. Source Control -> Commit
2. Write message, commit
3. Source Control -> Push

## 8) Golden rule after each work session
Run this every time:
```bash
git add .
git commit -m "checkpoint"
git push
```

You can also create a private backup zip:
```bash
cd ~/Documents
zip -r AuraOS-Rebuild-backup-$(date +%Y%m%d-%H%M).zip AuraOS-Rebuild
```
