# Repo Agents

This repository includes a repo-local Codex plugin for syncing UIKit package changes into the docs site.

## Available local agent

- `FV UIKit Sync Agent`
  - Plugin path: `plugins/fv-uikit-sync-agent`
  - Skill: `fv-uikit-sync`
  - Purpose: compare the source package at `/Users/tuong.le/Documents/Finviet/ecopos_flutter_app/packages/fv_uikit_flutter` with the repo-local copy in `packages/fv_uikit_flutter`, then integrate relevant updates into this repo only.

## What it should do

- Pull the latest relevant changes from the source `fv_uikit_flutter` package into this repo.
- Reconcile repo-specific docs integration instead of blindly overwriting files.
- Update docs content, examples, and tests when package changes make them stale.
- Keep all writes inside this repository.

## What it must not do

- Do not modify `/Users/tuong.le/Documents/Finviet/ecopos_flutter_app/packages/fv_uikit_flutter`.
- Do not assume all differences should be overwritten.
- Do not revert unrelated user changes in this repo.

## How to trigger it

Use prompts such as:

- `Sync the latest fv_uikit_flutter changes into this docs repo`
- `Compare the source fv_uikit_flutter package and refresh the local package copy`
- `Update this repo from fv_uikit_flutter and reconcile docs/test changes`
