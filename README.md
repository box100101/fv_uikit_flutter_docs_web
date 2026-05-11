# FV UIKit Docs Web

Static documentation site for `fv_uikit_flutter`, built with `Flutter Web` and backed by the real UIKit package as a local dependency.

## What Is Included

- Responsive docs shell with grouped navigation for foundations, inputs, and overlays
- Hardcoded bilingual `VI + EN` content model
- Full prop reference for every exported public UIKit widget
- Live examples that render the real package widgets
- GitHub Pages workflow for publishing from the `uikit_docs_web` repository

## Local Development

```bash
flutter pub get
flutter run -d chrome
```

## Verification

```bash
flutter analyze
flutter test
flutter build web --release --base-href /uikit_docs_web/
```

## Dependency

This site depends on the local package:

```text
../ecopos_flutter_app/packages/fv_uikit_flutter
```

## Deploy To GitHub Pages

1. Push this repository to GitHub as `uikit_docs_web`.
2. In GitHub, enable Pages with `Build and deployment -> GitHub Actions`.
3. The included workflow builds with:

```bash
flutter build web --release --base-href /uikit_docs_web/
```

4. After the workflow completes, the site will be available at:

```text
https://<your-github-username>.github.io/uikit_docs_web/
```
