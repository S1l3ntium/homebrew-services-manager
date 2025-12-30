# Distribution Flow / Процесс распространения

## Complete Distribution Process / Полный процесс распространения

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        HOMEBREW SERVICES MANAGER                        │
│                         Distribution Pipeline                           │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: GitHub Setup (Один раз)
═════════════════════════════════

  Your Computer                              GitHub
  ─────────────                              ──────
  $ git remote add origin ...  ──────────→  homebrew-services-manager repo
  $ git push -u origin main    ──────────→  Synced ✓


STEP 2: Create Release (При каждом новом релизе)
═════════════════════════════════════════════════

  Your Computer                              GitHub
  ─────────────                              ──────
  $ swift build -c release

  $ gh release create v1.0  ───────────────→  Creates Release Tag
        HomebrewServicesManager
                                            ✓ v1.0 Release Page
                                            ✓ Binary uploaded


STEP 3: Get SHA256 Hash (После загрузки бинаря)
═════════════════════════════════════════════════

  $ shasum -a 256 .build/release/HomebrewServicesManager

  Output: abc123def456... ← Copy this for Cask formula


STEP 4: Create Homebrew Tap (Один раз)
═════════════════════════════════════════

  GitHub Setup                               Your Computer
  ─────────────                              ──────────────
  Create: homebrew-tap repo  ←───────────── $ git clone ...
                                            $ mkdir Casks/
                                            $ cat > homebrew-services-manager.rb


STEP 5: Update Cask Formula (При каждом новом релизе)
═══════════════════════════════════════════════════════

  In homebrew-services-manager.rb:

  version '1.0'
  sha256 'abc123def456...'
  url "https://github.com/USERNAME/.../releases/download/v1.0/..."


STEP 6: Push to Tap (При каждом обновлении)
═══════════════════════════════════════════

  Your homebrew-tap folder                   GitHub
  ──────────────────────────                 ──────
  $ git commit ...  ─────────────────────→  homebrew-tap repo updated
  $ git push        ─────────────────────→  Cask formula available


STEP 7: User Installation
═════════════════════════

  User's Computer
  ───────────────
  $ brew tap USERNAME/tap
             ↓
  Fetches: https://github.com/USERNAME/homebrew-tap
             ↓
  $ brew install --cask homebrew-services-manager
             ↓
  Downloads binary from your GitHub releases
             ↓
  Installs to /usr/local/bin/
             ↓
  ✓ Ready to use!

```

---

## Repository Structure / Структура репозиториев

### Main Repository (homebrew-services-manager)
```
homebrew-services-manager/
├── Sources/
│   ├── App/          → Main application
│   ├── Core/         → Core functionality
│   └── SystemModule/ → System integration
├── Package.swift     → Swift Package manifest
├── README.md         → User documentation
├── VERSION.md        → Release notes
├── HOMEBREW_CASK.md  → Detailed Cask guide ← You are here
└── .git/
```

### Tap Repository (homebrew-tap) - Create separately
```
homebrew-tap/
├── Casks/
│   └── homebrew-services-manager.rb  ← Copy from main repo
├── README.md
└── .git/
```

---

## Files Needed for Cask Distribution

### 1. In Main Repository (this project)
- ✓ `Package.swift` - Swift build configuration
- ✓ `Sources/` - Application source code
- ✓ `README.md` - Documentation (UPDATED)
- ✓ `homebrew-services-manager.rb` - Cask formula template (NEW)

### 2. In Tap Repository (create new)
- `Casks/homebrew-services-manager.rb` - Copy and customize

### 3. GitHub Releases
- `HomebrewServicesManager` binary from `swift build -c release`

---

## Version Update Workflow / Рабочий процесс обновления версии

```
v1.0 Release:
┌────────────────────────────────────────────────────────────────┐
│ 1. Swift build -c release                                       │
│    └→ .build/release/HomebrewServicesManager (758 KB)          │
│                                                                 │
│ 2. gh release create v1.0 HomebrewServicesManager              │
│    └→ GitHub Release page created                             │
│    └→ Binary uploaded                                         │
│                                                                 │
│ 3. shasum -a 256 .build/release/HomebrewServicesManager       │
│    └→ abc123def456...                                         │
│                                                                 │
│ 4. Update Casks/homebrew-services-manager.rb:                 │
│    - version '1.0'                                             │
│    - sha256 'abc123def456...'                                 │
│    - url points to v1.0 release                               │
│                                                                 │
│ 5. Push to homebrew-tap                                        │
│    └→ Available for users to install                          │
└────────────────────────────────────────────────────────────────┘

v1.1 Release (same process):
┌────────────────────────────────────────────────────────────────┐
│ $ git tag v1.1                                                  │
│ $ swift build -c release                                        │
│ $ gh release create v1.1 HomebrewServicesManager              │
│ $ shasum -a 256 .build/release/HomebrewServicesManager       │
│ $ # Update Casks/homebrew-services-manager.rb in tap repo     │
│ $ git push to homebrew-tap                                     │
│ ✓ Users get v1.1 automatically                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## Checklist for Publishing / Чеклист для публикации

### Before Release (Перед релизом)
- [ ] Code is tested and working
- [ ] Version numbers updated in documentation
- [ ] Build succeeds: `swift build -c release`
- [ ] No compilation errors or warnings

### Release Day (День релиза)
- [ ] Create git tag: `git tag v1.0`
- [ ] Create GitHub Release with binary
- [ ] Compute SHA256 of binary
- [ ] Update `homebrew-services-manager.rb` with new SHA256
- [ ] Push to homebrew-tap repository

### After Release (После релиза)
- [ ] Test installation: `brew tap .../homebrew-tap && brew install --cask homebrew-services-manager`
- [ ] Verify app works after installation
- [ ] Announce release on social media/forums if desired

---

## Quick Reference / Быстрая справка

### One-time setup:
```bash
# On GitHub create: homebrew-tap repository

# Locally:
git clone https://github.com/USERNAME/homebrew-tap.git
mkdir homebrew-tap/Casks
```

### Every release:
```bash
# In main repository:
swift build -c release
gh release create v1.0 .build/release/HomebrewServicesManager
HASH=$(shasum -a 256 .build/release/HomebrewServicesManager | cut -d' ' -f1)
echo $HASH  # Copy this

# In homebrew-tap repository:
# Edit Casks/homebrew-services-manager.rb:
# - Update version to '1.0'
# - Update sha256 to $HASH
git commit -am "Update to v1.0"
git push
```

### User installs with:
```bash
brew tap USERNAME/tap
brew install --cask homebrew-services-manager
```

---

## Troubleshooting / Решение проблем

### SHA256 mismatch error
- Verify you computed SHA256 from the uploaded file on GitHub, not local copy
- Re-compute: `shasum -a 256 <path-to-binary>`

### Brew can't find the tap
- Verify tap repository exists and is public
- Verify tap repository is named `homebrew-tap`
- Check URL in formula is correct

### Installation fails with checksum error
- Ensure SHA256 in formula matches actual binary
- Download binary directly from GitHub to verify

### Binary not found in release
- Verify `gh release upload v1.0 <binary-path>`
- Check GitHub release page - binary should be there

---

## Additional Resources

- [Homebrew Cask Documentation](https://docs.brew.sh/Cask-Cookbook)
- [GitHub CLI Reference](https://cli.github.com/manual/)
- [Swift Package Manager Guide](https://swift.org/package-manager/)

---

**Status:** Ready for distribution ✓
**Current Version:** 1.0
**Last Updated:** 2025-12-30
