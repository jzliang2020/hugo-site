#!/usr/bin/env bash
set -euo pipefail

rsync -av --delete \
  --exclude '.git/' \
  --exclude 'resources/_gen/' \
  /home/ljz/hugo_site/ \
  /mnt/c/Users/ljz/Documents/Codex/2026-08-04/new-chat/hugo_site_wsl_mirror/
