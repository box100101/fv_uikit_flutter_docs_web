---
name: fv-uikit-sync
description: Sync the latest `fv_uikit_flutter` package changes from the source workspace into this docs repo, then reconcile docs, examples, and tests with the repo's current structure. Use when the user asks to sync, refresh, pull in, or integrate package changes for `fv_uikit_flutter`.
---

# FV UIKit Sync

Use this skill when working inside `/Users/tuong.le/Documents/Finviet/uikit_docs_web` and the task is to integrate the newest package changes from:

`/Users/tuong.le/Documents/Finviet/ecopos_flutter_app/packages/fv_uikit_flutter`

into the current repo-local copy at:

`/Users/tuong.le/Documents/Finviet/uikit_docs_web/packages/fv_uikit_flutter`

## Goal

- Bring relevant source-package updates into this repo.
- Preserve the current docs app structure and conventions.
- Update docs content, examples, and tests when package/API changes make them stale.
- Never modify the source package in `ecopos_flutter_app`.

## Constraints

- Only edit files inside the current repo.
- Treat the source package as read-only.
- Do not blindly overwrite the docs repo if it has repo-specific customizations. Reconcile changes with care.
- Prefer one-way sync from source package to docs repo.

## Workflow

1. Inspect the current repo setup.
   - Check `pubspec.yaml`, `README.md`, `lib/src/docs/**`, `test/**`, and `packages/fv_uikit_flutter/**`.
   - Confirm the docs repo uses the local package copy.

2. Compare the local package copy with the source package.
   - Prioritize `lib/**`, `pubspec.yaml`, public exports, tests, and examples that affect consumer behavior.
   - Ignore generated build artifacts and ephemeral folders.

3. Apply source changes into the current repo.
   - Update `packages/fv_uikit_flutter/**` as needed.
   - Reconcile any differences instead of assuming the source should overwrite everything.

4. Reconcile docs integration.
   - Review `lib/src/docs/content.dart` and `lib/src/docs/examples.dart` for stale props, widget names, token values, or examples.
   - Update docs routes, content, and tests when needed.

5. Verify locally when possible.
   - Run the most relevant checks available for the current change set:
     - `flutter analyze`
     - `flutter test`
     - `flutter build web --release --base-href /fv_uikit_flutter_docs_web/`

6. Report clearly.
   - Summarize what changed.
   - List files touched.
   - Note verification results.
   - Call out any unresolved drift or follow-up work.

## Good prompts

- Sync the latest `fv_uikit_flutter` changes into this repo.
- Compare the source package and refresh the local package copy plus docs.
- Pull in new UIKit changes and fix any docs or test mismatches.
