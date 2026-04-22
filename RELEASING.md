# Releasing

This monorepo ships three independently-versioned packages. Each has its own
release workflow, tag convention, and publish destination.

| Package           | Tag (stable)               | Tag (preview)                        | Publishes to                                |
| ----------------- | -------------------------- | ------------------------------------ | ------------------------------------------- |
| PSDocs            | `psdocs-vX.Y.Z`            | `psdocs-vX.Y.Z-preview.N`            | PowerShell Gallery (`PSDocs`)               |
| PSDocs.Azure      | `psdocs-azure-vX.Y.Z`      | `psdocs-azure-vX.Y.Z-preview.N`      | PowerShell Gallery (`PSDocs.Azure`)         |
| VS Code Extension | `vscode-vX.Y.Z`            | `vscode-preview-vX.Y.Z`              | VS Marketplace (`vicperdana.psdocs-vscode` / `…-preview`) |

All three workflows also create a GitHub Release on this repo with notes
extracted from the relevant `CHANGELOG.md` and (for VS Code) the `.vsix`
attached.

> **VS Code is special.** The Marketplace does not accept SemVer prerelease
> suffixes (`-preview.N`) in the package version. Channel is encoded in the
> **tag prefix** (`vscode-preview-v…`) and routed via the build pipeline's
> `-Channel preview` parameter, which produces a separate extension ID
> (`vicperdana.psdocs-vscode-preview`). Both channels publish plain `X.Y.Z`
> versions.

## One-time prerequisites

### 1. PowerShell Gallery API key

1. Sign in at <https://www.powershellgallery.com> with an account that is a
   co-owner of `PSDocs` and `PSDocs.Azure`.
2. **Profile → API Keys → Create**:
   - Glob pattern: `PSDocs;PSDocs.Azure`
   - Scopes: `Push new packages and package versions` + `Unlist packages`
   - Expiration: 365 days (calendar a renewal reminder).
3. Copy the key.
4. In this repo: **Settings → Secrets and variables → Actions → New repository
   secret**, name `PSGALLERY_API_KEY`.

### 2. VS Marketplace personal access token

1. At <https://dev.azure.com/{your-org}> (the Azure DevOps org backing the
   `vicperdana` Marketplace publisher), open **User settings → Personal access
   tokens → New Token**:
   - Organization: **All accessible organizations**
   - Scopes: **Custom defined → Marketplace → Manage**
   - Expiration: 365 days max.
2. Copy the token.
3. In this repo: add it as a secret named `VSCE_PAT`.

### 3. `release` GitHub Environment (manual approval gate)

1. **Settings → Environments → New environment** named `release`.
2. **Required reviewers**: add yourself (and optionally a co-maintainer).
3. **Deployment branches and tags**: select **Selected branches and tags**, add
   three tag rules:
   - `psdocs-v*`
   - `psdocs-azure-v*`
   - `vscode-v*`
   - `vscode-preview-v*`
4. Confirm — both `PSGALLERY_API_KEY` and `VSCE_PAT` are accessible to jobs
   that target this environment.

## Cutting a release

The same shape applies to all three packages. The differences are: which
files get bumped, which CHANGELOG you update, and which tag prefix you push.

### Step 1 — Bump version

| Package           | Edit                                                                  |
| ----------------- | --------------------------------------------------------------------- |
| PSDocs            | `packages/psdocs/src/PSDocs/PSDocs.psd1` → `ModuleVersion = 'X.Y.Z'`  |
| PSDocs.Azure      | `packages/psdocs-azure/src/PSDocs.Azure/PSDocs.Azure.psd1` → `ModuleVersion = 'X.Y.Z'` |
| VS Code Extension | `packages/vscode-extension/package.json` → `"version": "X.Y.Z"`       |

The release workflow validates the manifest version against the tag and
**fails fast on mismatch**.

### Step 2 — Update CHANGELOG

Add a new section at the top of the relevant CHANGELOG immediately after the
`## Unreleased` heading:

```markdown
## vX.Y.Z

What's changed since vA.B.C:

- Category:
  - Description. [#PR](link)
```

| Package           | CHANGELOG path                                       |
| ----------------- | ---------------------------------------------------- |
| PSDocs            | `packages/psdocs/CHANGELOG.md`                       |
| PSDocs.Azure      | `CHANGELOG.md` (repo root)                           |
| VS Code Extension | `packages/vscode-extension/CHANGELOG.md`             |

The release workflow uses `scripts/extract-release-notes.ps1` to pull this
section verbatim into the GitHub Release notes. Keep the heading exactly as
`## vX.Y.Z` (a date in parentheses is also accepted, e.g. `## v0.4.0 (15 May 2026)`).

### Step 3 — Commit on a release branch and merge

```bash
git checkout -b release/psdocs-azure-v0.5.0
git add packages/psdocs-azure/src/PSDocs.Azure/PSDocs.Azure.psd1 CHANGELOG.md
git commit -m "release: PSDocs.Azure v0.5.0"
git push -u origin release/psdocs-azure-v0.5.0
gh pr create --fill --base main
# review + merge
```

### Step 4 — Tag and push

After merge, on `main` at the merge commit:

```bash
git checkout main
git pull --ff-only
git tag -a psdocs-azure-v0.5.0 -m "PSDocs.Azure v0.5.0"
git push origin psdocs-azure-v0.5.0
```

### Step 5 — Approve the release in GitHub Actions

1. Open **Actions → Release {Package}** — the run is paused at the `release`
   environment gate.
2. Click **Review deployments → Approve and deploy**.
3. Watch the run complete.

### Step 6 — Verify

| Package      | Verification                                                                    |
| ------------ | ------------------------------------------------------------------------------- |
| PSDocs       | `Find-Module PSDocs -Repository PSGallery` shows the new version                |
| PSDocs.Azure | `Find-Module PSDocs.Azure -Repository PSGallery` shows the new version          |
| VS Code      | <https://marketplace.visualstudio.com/items?itemName=vicperdana.psdocs-vscode> |
| All three    | <https://github.com/Azure/PSDocs.Azure/releases> shows the new release          |

For VS Code, also confirm the `.vsix` is attached to the GitHub Release.

## Pre-release flow

### PSDocs / PSDocs.Azure

The PowerShell Gallery accepts SemVer 2.0 prerelease suffixes. Tag with the
suffix appended:

```bash
git tag -a psdocs-azure-v0.5.0-preview.1 -m "PSDocs.Azure v0.5.0-preview.1"
git push origin psdocs-azure-v0.5.0-preview.1
```

The workflow strips `-preview.1` from the tag, validates the *base* version
(`0.5.0`) against the manifest's `ModuleVersion`, then `Update-ModuleManifest`
sets the `PSData.Prerelease` field to `preview1` (the pipeline removes the dot
to satisfy the gallery's prerelease character rules) before publish. The
GitHub Release is marked as a pre-release.

> **`-preview.N` increments**: Each preview iteration must increment `N`. You
> cannot republish the same version (e.g. `…-preview.1` twice) — PSGallery
> returns 409.

### VS Code Extension

Use the dedicated tag prefix:

```bash
git tag -a vscode-preview-v0.5.0 -m "VS Code Extension v0.5.0 (preview)"
git push origin vscode-preview-v0.5.0
```

The workflow routes this to `Invoke-Build -Channel preview`, which sets the
extension ID to `vicperdana.psdocs-vscode-preview`, sets `package.preview =
true`, publishes with `vsce publish --pre-release`, and marks the GitHub
Release as a pre-release.

> Preview and stable extensions are **separate Marketplace listings**. Users
> install one or the other; they do not auto-cross-upgrade.

## Troubleshooting

### `Manifest ModuleVersion 'A.B.C' does not match tag base version 'X.Y.Z'`

You forgot Step 1 (bump the manifest). Either re-tag after fixing the manifest
on `main`, or delete the offending tag:

```bash
git tag -d psdocs-azure-v0.5.0
git push origin :refs/tags/psdocs-azure-v0.5.0
# bump manifest, commit, then re-tag
```

### `Section 'vX.Y.Z' is empty in CHANGELOG.md`

The CHANGELOG section heading exists but has no body. Add release notes
under the heading (Step 2). If you genuinely want to publish with no notes,
re-run with `-AllowEmpty` by editing the workflow temporarily — but this is
strongly discouraged.

### PSGallery `409 Conflict`

You're trying to republish an existing version. PSGallery never allows this.
Bump to the next patch version (or next `-preview.N`) and re-tag.

### `vsce publish` returns `Extension version 'X.Y.Z' is not greater than the published version`

The Marketplace already has this version. Bump `package.json` and the tag.

### `vsce` rejects the package because `engines.vscode > @types/vscode`

Ensure `@types/vscode` in `package.json` is `~` pinned to the same minor as
`engines.vscode`. See <https://github.com/microsoft/vscode-vsce/issues/787>.

### `release` environment never approves automatically

By design — manual approval is the safety gate. If you're the only reviewer
and need to ship outside business hours, the approval link is in the workflow
run page.

## Rollback

> **Never republish an already-published version.** Always roll forward.

| Registry           | Action                                                       |
| ------------------ | ------------------------------------------------------------ |
| PowerShell Gallery | Sign in → package page → **Manage Owners** / **Unlist**     |
| VS Marketplace     | `npx @vscode/vsce unpublish vicperdana.psdocs-vscode@X.Y.Z` |
| GitHub Release     | `gh release delete vscode-vX.Y.Z` then `git push origin :refs/tags/vscode-vX.Y.Z` |

Then ship a new version with the fix.

## Quick reference

```text
PSDocs           tag: psdocs-vX.Y.Z              (preview: psdocs-vX.Y.Z-preview.N)
PSDocs.Azure     tag: psdocs-azure-vX.Y.Z        (preview: psdocs-azure-vX.Y.Z-preview.N)
VS Code          tag: vscode-vX.Y.Z              (preview: vscode-preview-vX.Y.Z)

Secrets:  PSGALLERY_API_KEY, VSCE_PAT
Env:      release (with reviewers + tag-restricted)
Notes:    auto-extracted via scripts/extract-release-notes.ps1
```
