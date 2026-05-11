# FV UIKit Docs Web

Static documentation site for `fv_uikit_flutter`, built with `Flutter Web` and backed by the real UIKit package as a local dependency.

## What Is Included

- Responsive docs shell with grouped navigation for foundations, inputs, and overlays
- Hardcoded bilingual `VI + EN` content model
- Full prop reference for every exported public UIKit widget
- Live examples that render the real package widgets
- GitHub Pages workflow for publishing from the `fv_uikit_flutter_docs_web` repository

## Local Development

```bash
flutter pub get
flutter run -d chrome
```

## Verification

```bash
flutter analyze
flutter test
flutter build web --release --base-href /fv_uikit_flutter_docs_web/
```

## Dependency

This site depends on the local package:

```text
packages/fv_uikit_flutter
```

## Local Agent

This repo includes a repo-local Codex plugin for one-way UIKit sync:

- Plugin: `FV UIKit Sync Agent`
- Skill: `fv-uikit-sync`
- Marketplace: `.agents/plugins/marketplace.json`

Use it when you want Codex to compare the source package at `/Users/tuong.le/Documents/Finviet/ecopos_flutter_app/packages/fv_uikit_flutter` with the repo-local copy in `packages/fv_uikit_flutter`, then integrate relevant changes into this repo without writing back to the source package.

## Deploy To GitHub Pages

1. Push this repository to GitHub as `fv_uikit_flutter_docs_web`.
2. In GitHub, enable Pages with `Build and deployment -> GitHub Actions`.
3. The included workflow builds with:

```bash
flutter build web --release --base-href /fv_uikit_flutter_docs_web/
```

4. After the workflow completes, the site will be available at:

```text
https://<your-github-username>.github.io/fv_uikit_flutter_docs_web/
```